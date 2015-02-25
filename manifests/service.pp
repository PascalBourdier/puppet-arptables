class arptables::service {
  service { 'arptables_jf':
    enable  => $::arptables::service_enable,
    ensure  => $::arptables::service_ensure,
    }
}