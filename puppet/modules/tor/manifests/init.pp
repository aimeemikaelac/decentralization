class tor(
	$nodeip = undef,
	$authoritycertfingerprint = undef,
	$authorityfingerprint = undef,
	$authorityip = undef,
	$isAuthority = false,
	$isRouter = false,
){
	$packages_list = ["openssh-server", "avahi-utils", "git", "tor"]

	package{$packages_list: ensure => "latest"}

	exec{ "chown root tor":
		command => "/bin/chown -R root.root /var/lib/tor; /bin/chown -R root.root /etc/tor",
		require => Package["tor"]
	}

	exec{'gen keys':
		command => "tor --list-fingerprint --orport 1 --dirserver \"x 127.0.0.1:1 ffffffffffffffffffffffffffffffffffffffff\" --datadirectory /var/lib/tor/",
		require => Exec['chown root tor'],
	}

	if $isAuthority {
		file{"keydir":
			path    => "/var/lib/tor/keys",
			ensure  => 'directory',
			owner   => 'root',
			group   => 'root',
			mode    => '0700',
			require => Exec['chown root tor'],
		}

		exec{ "gen certs":
			command => "tor-gencert --create-identity-key -m 12 -a ${nodeip}:7000 -i /var/lib/tor/keys/authority_identity_key -s /var/lib/tor/keys/authority_signing_key -c /var/lib/tor/keys/authority_certificate",
			require => Exec['keydir'],
		}

		exec{'extract cert fingerprint':
			command => "cat /var/lib/tor/keys/authority_certificate | grep fingerprint | sed 's/fingerprint //g' > /var/lib/tor/keys/authority_certificate_fingerprint",
			require => Exec['gen certs'],
		}

		#	$authoritycertfingerprint = file('/var/lib/tor/keys/authority_certificate_fingerprint')
		exec{'extract fingerprint':
			comand  => "cat /var/lib/tor/fingerprint | sed 's/^.\\{4\\}//' > /var/lib/tor/fingerprint_raw",
			require => Exec['gen keys'],
		}


		file{"/etc/torrc":
			path    => "/etc/tor/torrc",
			owner   => 'root',
			group   => 'root',
			mode    => '0644',
			require => [Exec["gen certs"], Exec['gen keys'], Exec['extract cert fingerprint'], Exec['extract fingerprint'], Package['tor']],
			content => template('tor/authorityconf.erb')
		}

		exec{"tor":
			command => "tor",
			require => File["/etc/torrc"],
		}
	}
}
