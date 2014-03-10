# == Class: dev::redissetup
#
class dev::redissetup {

    # include apt

    # apt::ppa { 'ppa:chris-lea/redis-server': }

    # package {
    #     'redis-server':
    #         ensure  => latest,
    #         require => [ Apt::Ppa['ppa:chris-lea/redis-server']];
    # }

    # service { 'redis-server':
    #     ensure     => 'running',
    #     enable     => true,
    #     hasstatus  => true,
    #     hasrestart => true,
    #     require    => Package['redis-server'],
    # }
}
