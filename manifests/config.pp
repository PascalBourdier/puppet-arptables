#
class arptables::config {

  unless $::arptables::service_enable == false {

    case $::operatingsystemmajrelease {
      '6': {
        $template = 'arptables/arptables.epp'
      }
      '7': {
        $template = 'arptables/arptables7.epp'
      }
      default: {
        fail("Unsupported operatingsystemmajrelease ${::operatingsystemmajrelease}")
      }
    }

    file { $::arptables::arp_packetfilter:
      ensure  => 'file',
      content => epp($template),
      #content => epp('arptables/arptables.epp'),
      owner   => 'root',
      group   => 'root',
      require => Class['arptables::install'],
      notify  => Class['arptables::service'],
    }

    if $::arptables::manage_ip_alias == true {

      # register yourself in rclocal
      ::rclocal::register{ 'arptables':
        content   => epp('arptables/add_ipalias.epp'),
        subscribe => File[$::arptables::arp_packetfilter],
      }

      case $::arptables::virtual_ip {
        String : {
          exec { "run_ip_add_${::arptables::virtual_ip}":
            command   => "/sbin/ip addr add ${::arptables::virtual_ip} dev ${::arptables::interface}",
            unless    => "/sbin/ip -4 a | grep ${::arptables::virtual_ip}",
            subscribe => File[$::arptables::arp_packetfilter],
            #refreshonly => true,
          }
        }
        Array : {
          each($::arptables::virtual_ip) |$value| {
            exec { "run_ip_add_${value}":
              command   => "/sbin/ip addr add ${value} dev ${::arptables::interface}",
              unless    => "/sbin/ip -4 a | grep ${value}",
              subscribe => File[$::arptables::arp_packetfilter],
              #refreshonly => true,
            }
          }
        }
        default: {
          fail('The $::arptables::virtual_ip is of type that is not supported')
        }
      }
    }
  }
}
