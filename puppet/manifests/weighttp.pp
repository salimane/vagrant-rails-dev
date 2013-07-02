# == Class: weighttp
#
class weighttp($username = 'vagrant') {

    package { ['libev-dev']:
        ensure => installed,
    }

    $home_dir = "/home/${username}"

    exec {
        'clone_weighttp':
            cwd     =>"${home_dir}/src",
            group   => $username,
            user    => $username,
            command => "git clone git://git.lighttpd.net/weighttp ${home_dir}/src/weighttp",
            require => [Package['git'], File["${home_dir}/src"]],
            creates => "${home_dir}/src/weighttp";

        'install_weighttp':
            provider => shell,
            cwd     =>"${home_dir}/src/weighttp",
            command => "${home_dir}/src/weighttp/waf configure; ${home_dir}/src/weighttp/waf build; ${home_dir}/src/weighttp/waf install",
            require => Exec['clone_weighttp'],
            creates => '/usr/local/bin/weighttp';
    }
}
