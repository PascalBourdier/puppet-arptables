#
class arptables::install {

  unless $::arptables::service_enable == false {

    case $::osfamily {
      'RedHat': {
        case $::operatingsystemmajrelease {
          '6': {
            package { 'arptables_jf':
              ensure => present,
            }
          }
          '7': {
            package { 'arptables':
              ensure => present,
            }
          }
          default: {
            fail("Unsupported operatingsystemmajrelease ${::operatingsystemmajrelease}")
          }
        }
      }
      default: {
        fail("The ${module_name} module is not supported on an ${::operatingsystem} distribution.")
      }
    }
  }
}
