#!/bin/bash
curl -O http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb
sudo apt-get update
sudo apt-get install -y puppet git tor
sudo chown -R root.root /var/lib/tor
sudo chown -R root.root /etc/tor
sudo "tor --list-fingerprint --orport 1 --dirserver \"x 127.0.0.1:1 ffffffffffffffffffffffffffffffffffffffff\" --datadirectory /var/lib/tor/"
sudo mkdir /var/lib/tor/keys
ip=$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
sudo "tor-gencert --create-identity-key -m 12 -a $ip:7000 -i /var/lib/tor/keys/authority_identity_key -s /var/lib/tor/keys/authority_signing_key -c /var/lib/tor/keys/authority_certificate"
sudo "cat /var/lib/tor/keys/authority_certificate | grep fingerprint | sed 's/fingerprint //g' > /var/lib/tor/keys/authority_certificate_fingerprint"
sudo "cat /var/lib/tor/fingerprint | sed 's/^.\\{4\\}//' > /var/lib/tor/fingerprint_raw"
