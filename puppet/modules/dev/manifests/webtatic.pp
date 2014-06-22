# Class Webtatic
#
# Actions:
#   Configure the proper repositories and import GPG keys
#
# Reqiures:
#   You should probably be on an Enterprise Linux variant. (Centos, RHEL, Scientific, Oracle, Ascendos, et al)
#
# Sample Usage:
#  include webtatic
#
class dev::webtatic  {

  if $::osfamily == 'RedHat' and $::operatingsystem != 'Fedora' {

    if $::operatingsystemrelease =~ /^5.*/  {
      $os_release = 'centos'
      $mirror_sub_path = "${os_release}/5"
    } elsif $::operatingsystemrelease =~ /^6.*/  {
      $os_release = 'el6'
      $mirror_sub_path = $os_release
    }

    yumrepo { 'webtatic':
      mirrorlist     => "http://repo.webtatic.com/yum/${mirror_sub_path}/${::architecture}/mirrorlist",
      failovermethod => 'priority',
      proxy          => 'absent',
      enabled        => '1',
      gpgcheck       => '1',
      gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-webtatic-andy',
      descr          => "Webtatic Repository ${os_release} - ${::architecture}",
      exclude        => $::exclude_pkgs,
    }

    yumrepo { 'webtatic-debuginfo':
      mirrorlist     => "http://repo.webtatic.com/yum/${mirror_sub_path}/${::architecture}/debug/mirrorlist",
      failovermethod => 'priority',
      proxy          => 'absent',
      enabled        => '0',
      gpgcheck       => '1',
      gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-webtatic-andy',
      descr          => "Webtatic Repository ${os_release} - ${::architecture} - Debug",
    }

    yumrepo { 'webtatic-source':
      mirrorlist     => "http://repo.webtatic.com/yum/${mirror_sub_path}/${::architecture}/SRPMS/mirrorlist",
      failovermethod => 'priority',
      proxy          => 'absent',
      enabled        => '0',
      gpgcheck       => '1',
      gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-webtatic-andy',
      descr          => "Webtatic Repository ${os_release} - ${::architecture}",
    }

    file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-webtatic-andy':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/dev/webtatic/RPM-GPG-KEY-webtatic-andy',
    }

    dev::webtatic::rpm_gpg_key{ 'webtatic':
      path   => '/etc/pki/rpm-gpg/RPM-GPG-KEY-webtatic-andy',
      before => Yumrepo ['webtatic','webtatic-debuginfo','webtatic-source']
    }

    #Virtual Exec to replace existing mysql install without having to uninstall mysql on the machine
    @exec {'webtatic-replace-mysql':
      command => 'yum -d 0 -e 0 -y install mysql.`uname -i` yum-plugin-replace && yum -d 0 -e 0 -y replace mysql --replace-with mysql55',
      onlyif  => 'yum list installed mysql-*',
      require => Yumrepo['webtatic'],
      timeout => '600',
    }

    #Use mysql module, but with mysql55 from webtatic
    @user { 'mysql':
      ensure => present,
      system => true,
      gid    => 'mysql',
      shell  => '/sbin/nologin',
    }
    @group { 'mysql':
      ensure => present,
      system => true,
    }
    #Make sure the user is in place before installing the mysql server package
    User['mysql'] -> Package <| name == 'mysql-server' |>

    #Resource ordering, make sure the yum repo is inplace before trying to install any of the mysql55 packages
    #Collectors so that it only occurs when/if the package is realized
    Yumrepo['webtatic'] -> Package <| name == 'mysql' |>
    Yumrepo['webtatic'] -> Package <| name == 'mysql-bench' |>
    Yumrepo['webtatic'] -> Package <| name == 'mysql-devel' |>
    Yumrepo['webtatic'] -> Package <| name == 'mysql-embedded' |>
    Yumrepo['webtatic'] -> Package <| name == 'mysql-embedded-devel' |>
    Yumrepo['webtatic'] -> Package <| name == 'mysql-libs' |>
    Yumrepo['webtatic'] -> Package <| name == 'mysql-server' |>
    Yumrepo['webtatic'] -> Package <| name == 'mysql-test' |>

    #For the Exec
    Exec['webtatic-replace-mysql'] -> Package <| name == 'mysql55' |>
    Exec['webtatic-replace-mysql'] -> Package <| name == 'mysql55-bench' |>
    Exec['webtatic-replace-mysql'] -> Package <| name == 'mysql55-devel' |>
    Exec['webtatic-replace-mysql'] -> Package <| name == 'mysql55-embedded' |>
    Exec['webtatic-replace-mysql'] -> Package <| name == 'mysql55-embedded-devel' |>
    Exec['webtatic-replace-mysql'] -> Package <| name == 'mysql55-libs' |>
    Exec['webtatic-replace-mysql'] -> Package <| name == 'mysql55-server' |>
    Exec['webtatic-replace-mysql'] -> Package <| name == 'mysql55-test' |>
  } else {
      notice ("Your operating system ${::operatingsystem} will not have the Webtatic repository applied")
  }
}
