# == Class: security
#
class security {

    package { ['fail2ban', 'htop', 'molly-guard', 'logwatch']:
        ensure => installed,
    }
}
