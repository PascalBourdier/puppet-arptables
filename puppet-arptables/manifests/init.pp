# Class: arptables
#
# This module manages arptables
# Userspace control program for the arptables network filter
class arptables (
  Boolean $service_enable = false,
  $service_ensure = 'stopped',
  $virtual_ip = undef,
  $real_ip = undef,
  $virtual_real_ip = undef,
  $arp_packetfilter = '/etc/sysconfig/arptables',
  $interface = undef,
  Boolean $manage_ip_alias = true,

  ) {
contain arptables::install
contain arptables::config
contain arptables::service
}

