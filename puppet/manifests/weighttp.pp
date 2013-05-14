# == Class: weighttp
#
class weighttp($username = 'vagrant') {

    package { ['libev-dev']:
        ensure => installed,
    }

    $home_dir = "/home/${username}"

    exec {
        'clone_weighttp':
            cwd     =>"${home_dir}/htdocs",
            group   => $username,
            user    => $username,
            command => "git clone git://git.lighttpd.net/weighttp ${home_dir}/htdocs/weighttp",
            require => [Package['git'], File["${home_dir}/htdocs"]],
            creates => "${home_dir}/htdocs/weighttp";

        'install_weighttp':
            cwd     =>"${home_dir}/htdocs/weighttp",
            command => "${home_dir}/htdocs/weighttp/waf configure && ${home_dir}/htdocs/weighttp/waf build && ${home_dir}/htdocs/weighttp/waf install",
            require => Exec['clone_weighttp'],
            creates => '/usr/local/bin/weighttp';
    }
}
