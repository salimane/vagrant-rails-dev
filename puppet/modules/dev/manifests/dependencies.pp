# Class: dev::dependencies
#
# This class installs common configuration for all dev nodes
#
# Parameters:
#
# Actions:
#   - Setup self-services team access to the servers
#   - Set sysctl variable for some improved performance
#
# Requires:
#   - epel
#   - webtatic
#   - userman_mw
#
# Sample Usage:
#   include dev::dependencies
#
#
class dev::dependencies($username = 'vagrant') {
  include epel
  include dev::webtatic
  include dev::sysctl
  package { ['tmux', 'curl', 'wget', 'glances', 'iotop', 'htop', 'nfs-utils', 'ncdu', 'nano']:
    ensure => installed,
  }
  file { '/etc/ssh/sshd_config' :  }

}
