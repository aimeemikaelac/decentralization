class authorityconf(){

	require [Exec["gen certs"], Exec['gen keys'], Exec['extract cert fingerprint'], Exec['extract fingerprint'], Package['tor']],

	file{"/etc/torrc":
		path    => "/etc/tor/torrc",
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		require => [Exec["gen certs"], Exec['gen keys'], Exec['extract cert fingerprint'], Exec['extract fingerprint'], Package['tor']],
		content => template('tor/authorityconf.erb')
	}
}
