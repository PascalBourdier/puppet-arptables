class arptables::service {
  service { 'arptables_jf':
    ensure => $::arptables::service_ensure,
    enable => $::arptables::service_enable,
  }
}
