# Definition: puppetsetup
#
class  puppetsetup {
    apt::source { 'puppetlabs':
        location   => 'http://apt.puppetlabs.com',
        repos      => 'main',
        key        => '4BD6EC30',
        key_server => 'pgp.mit.edu',
    }

    # puppet
    package {
        'puppet':
            ensure => latest;
    }
}