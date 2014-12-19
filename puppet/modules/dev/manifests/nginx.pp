# Class: dev::nginx
#
# This class setup configuration for the dev web nodes:
#
# Parameters:
#
# Actions:
#   - Install/setup/manage nginx configurations
#
# Requires:
#   - dev::dependencies
#
# Sample Usage:
#   class { 'dev::nginx' : username => 'vagrant', group => 'vagrant' }
#
#
class dev::nginx ($username = 'vagrant', $group = 'vagrant') {

  include dev::dependencies

  #manage nginx
  class { 'nginx::package':
    package_ensure => 'latest'
  }

  service { 'nginx':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    restart    => '/etc/init.d/nginx configtest && /etc/init.d/nginx restart',
    require    => Package['nginx'],
  }

  file { '/etc/nginx/ssl/':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { 'selfsigned.key':
    ensure  => present,
    path    => '/etc/nginx/ssl/selfsigned.key',
    source  => 'puppet:///modules/dev/nginx/ssl/selfsigned.key',
    notify  => Service['nginx'],
    require => Package['nginx'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { 'selfsigned.crt':
    ensure  => present,
    path    => '/etc/nginx/ssl/selfsigned.crt',
    source  => 'puppet:///modules/dev/nginx/ssl/selfsigned.crt',
    notify  => Service['nginx'],
    require => Package['nginx'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/nginx/conf.d/default.conf':
    ensure => absent,
    notify => Service['nginx'],
  }

  file { '/etc/nginx/conf.d/example_ssl.conf':
    ensure => absent,
    notify => Service['nginx'],
  }

  file { 'nginx.conf':
    ensure  => present,
    path    => '/etc/nginx/nginx.conf',
    source  => 'puppet:///modules/dev/nginx/nginx.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['nginx'],
    require => Package['nginx'],
  }

}
