# Class: arptables
#
# This module manages arptables
# Userspace control program for the arptables network filter
class arptables (
  Boolean $service_enable = false,
  String $service_ensure = 'stopped',
  Variant[Undef, String, Array] $virtual_ip = undef,
  Variant[Undef, String] $real_ip = undef,
  Variant[Undef, Hash] $virtual_real_ip = undef,
  String $arp_packetfilter = '/etc/sysconfig/arptables',
  Variant[Undef, String] $interface = undef,
  Boolean $manage_ip_alias = true,

  ) {
contain arptables::install
contain arptables::config
contain arptables::service
}
