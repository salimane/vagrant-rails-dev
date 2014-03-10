# Class: dev::sysctl
#
# This class sets Sysctl configuration for all dev nodes
#
# Parameters:
#
# Actions:
#   - Set sysctl variable for some improved performance
#
# Requires:
#
# Sample Usage:
#   include dev::sysctl
#
#
class dev::sysctl {

  # sysctl
  sysctl { 'vm.swappiness':                value => '0' }
  sysctl { 'net.ipv4.tcp_timestamps':      value => '0' }
  sysctl { 'net.ipv4.tcp_sack':            value => '1' }

  sysctl { 'net.ipv4.tcp_fin_timeout':     value => '15' }
  sysctl { 'net.ipv4.tcp_keepalive_intvl': value => '30' }
  sysctl { 'net.ipv4.tcp_tw_reuse':        value => '1' }

  # sysctl { 'net.ipv4.ip_local_port_range': value => '"2000 65000"'}
  sysctl { 'net.ipv4.tcp_window_scaling':  value => '1' }
  sysctl { 'net.ipv4.tcp_max_syn_backlog': value => '40000' }
  sysctl { 'net.core.somaxconn':           value => '4000' }
  sysctl { 'net.ipv4.tcp_max_tw_buckets': value => '2000' }

  # setting limits
  dev::basic::set_limits { 'any-soft': domain => '*', type => soft, item => nofile, value =>  65536 }
  dev::basic::set_limits { 'any-hard': domain => '*', type => hard, item => nofile, value =>  65536 }

}
