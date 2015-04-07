class reverse_proxy::getservers{
	package { ["epel-release","dockers","curl","jq"]: ensure => present }
}