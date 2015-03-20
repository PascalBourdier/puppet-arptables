class arptables::install {

  unless $::arptables::service_enable == false {

    case $::osfamily {
      'RedHat': {
        package { 'arptables_jf':
          ensure => present,
        }
      }
      default: {
        fail("The ${module_name} module is not supported on an ${::operatingsystem} distribution.")
      }
    }
  }
}
