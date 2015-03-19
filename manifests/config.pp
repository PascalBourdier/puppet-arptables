class arptables::config {

    file { $::arptables::arp_packetfilter:
      content => epp("arptables/arptables.epp"),
      owner   => 'root', 
      group   => 'root',
      ensure  => 'file',
      require => Class['arptables::install'],
      notify  => Class['arptables::service'],
    }

if $::arptables::manage_ip_alias == true {

    # register yourself in rclocal
    ::rclocal::register{ 'arptables': 
      content    => epp("arptables/add_ipalias.epp"),
      subscribe  => File[$::arptables::arp_packetfilter],
    }
    
    case $::arptables::virtual_ip {
      String : {
        exec { "run_ip_add_${::arptables::virtual_ip}":
          command     => "/sbin/ip addr add ${::arptables::virtual_ip} dev ${::arptables::interface}",
          unless      => "/sbin/ip -4 a | grep ${::arptables::virtual_ip}",
          subscribe   => File[$::arptables::arp_packetfilter],
          refreshonly => true,
        }
      }
      Array : {
        each($::arptables::virtual_ip) |$value| { 
          exec { "run_ip_add_${value}":
            command     => "/sbin/ip addr add ${value} dev ${::arptables::interface}",
            unless      => "/sbin/ip -4 a | grep ${value}",
            subscribe   => File[$::arptables::arp_packetfilter],
            refreshonly => true,
          }
        }        
      }
    }
  }
  }
