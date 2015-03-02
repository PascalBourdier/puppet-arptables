#puppet-arptables

This module makes use of the Puppet Type System and EPP templates, so it only works in 3.7 when the future parser is enabled.

On RedHat, in a direct routing load balancer setup, this module configures direct routing on real servers using arptables_jf.

This module manages `/etc/sysconfig/arptables`. With its default settings, it will also add ip aliasses and overwrite `/etc/rc.d/rc.local`. Set `manage_ip_alias` to false to prevent changes to `rc.local`.

##Parameters

###service_enable
    Default: false (boolean)

###service_ensure
    Default: stopped

The reasoning behind above defaults is that often the PREROUTING chain in iptables is used to achieve the same goal. So in order to configure direct routing using arptables_jf, you must change these defaults.

###manage_ip_alias
    Default: true (boolean)
    
If not already configured, adds ip aliasses to the interface specified in `interface` and adds them to `rc.local` for configuration to persist after reboots.

###virtual_ip
    Default: undef

Always specify `virtual_ip`, as string or array, when `manage_ip_alias` is true. In addition to adding ip aliasses through `rc.local`, it is used for configuring arptables when there is a single real ip on the system.

###real_ip
    Default: undef
Specify `real_ip` string only when there is a sigle real ip, otherwise use `virtual_real_ip` mapping.

###virtual_real_ip
    Default: undef

`virtual_real_ip` hash is used to configure arptables when there are multiple real ips on the system.
    
###interface
    Default: undef

Always specify interface when `manage_ip_alias` is true (default). It is used in adding ip aliasses through `rc.local`.

# Usage

Sample Hiera configurations

`serverone.yaml`

    arptables::service_enable: true
    arptables::service_ensure: running
    arptables::virtual_ip: 10.0.2.20
    arptables::real_ip: 10.0.2.15
    arptables::interface: eth0

`servertwo.yaml`

    arptables::service_enable: true
    arptables::service_ensure: running
    arptables::virtual_ip:
      - 172.31.168.20
      - 172.31.168.22
      - 172.31.168.24
    arptables::interface: eth0
    arptables::virtual_real_ip:
      172.31.168.20: '172.31.168.30'
      172.31.168.22: '172.31.168.32'
      172.31.168.24: '172.31.168.34'
