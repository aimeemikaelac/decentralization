File {
	owner => root,
	group => root,
}

Exec {
        path => [
                "/usr/local/sbin",
                "/usr/local/bin",
                "/usr/sbin",
                "/usr/bin",
                "/sbin",
                "/bin",
        ]
}

#include ::csel
#include vim
#include ::accounts

notify{'test':}

node default{
	notify{'virtualbox':}
	class {'tor':
		nodeip = $ipaddress,
		authorityip = $ipaddress,
		isAuthority = true,
		isRouter = true,
	}
}

