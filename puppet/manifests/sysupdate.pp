# Class: systemUpdate
#
# Manages systemUpdate.
#
# Usage:
# include systemUpdate
#
class sysupdate{
    Exec['aptupdate'] -> Package <| |>
    #Exec['aptupgrade'] -> Package <| |>
    # run apt-get update before anything else runs
    class {'basic::update_aptget': stage => first} ->
    class {'basic::upgrade_aptget':} ->
    class {'basic::packages':}
}

# just some packages
class basic::packages{
    $sysPackages = [ 'build-essential', 'zlib1g-dev', 'libssl-dev', 'libreadline-gplv2-dev', 'ssh', 'aptitude',
    'zsh', 'git' , 'software-properties-common', 'language-pack-zh-hans-base', 'subversion', 'tmux', 'curl', 'pandoc', 'wget']
    package { $sysPackages:
        require => Exec['aptupgrade'],
        ensure => installed
    }

}

# brings the system up-to-date after importing it with Vagrant
# runs only once after booting (checks /tmp/apt-get-update existence)
class basic::update_aptget{
    # class { 'apt':
    #     always_apt_update    => false,
    #     disable_keys         => undef,
    #     proxy_host           => false,
    #     proxy_port           => '8080',
    #     purge_sources_list   => false,
    #     purge_sources_list_d => false,
    #     purge_preferences_d  => false
    # }
    exec{'aptupdate':
        command => 'apt-get -y autoremove; apt-get -y autoclean; apt-get  -y -f install; apt-get update; touch /tmp/apt-get-updated',
        timeout => 0,
        #unless => "test -e /tmp/apt-get-updated"
    }
}

# brings the system up-to-date after importing it with Vagrant
# runs only once after booting (checks /tmp/apt-get-update existence)
class basic::upgrade_aptget{
  exec { 'aptupgrade':
        command => 'apt-get -y upgrade --fix-missing',
        timeout => 0,
        require => Exec['aptupdate']
    }
}
