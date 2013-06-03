# == Class: security
#
class security {

    package { ['fail2ban', 'htop', 'molly-guard', 'etckeeper', 'logwatch']:
        ensure => installed,
    }
}
