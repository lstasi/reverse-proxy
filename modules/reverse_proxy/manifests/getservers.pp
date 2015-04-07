class reverse_proxy::getservers{
	package { "epel-release": ensure => present }
	package { ["docker-io","curl","jq"]: 
				ensure => present,
				require => Package["epel-release"]}
	service { "docker":
			   ensure => "running",
			   require => Package["docker-io"]
			} 
}