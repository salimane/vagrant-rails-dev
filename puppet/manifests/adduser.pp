# Definition: add_user
#
# Description
#
# Parameters:
#  $name -
#  $uid -
#  $shell -
#  $groups -
#  $sshkeytype -
#  $sshkey -
#
# Actions:
#
# Requires:
#  This definition has no requirements.
#
# Sample Usage:
#  add_user { 'salimane':
#  uid                                          => 5001,
#  shell                                        => '/bin/zsh',
#  groups                                       => ['sudo', 'admin'],
#  sshkeytype                                   => 'ssh-rsa',
#  sshkey                                       => ''
# }
define adduser ($uid = undef, $shell, $groups, $sshkeytype = undef, $sshkey = undef) {

    $username = $title

    user { $username:
        comment    =>  $username,
        home       => "/home/${username}",
        shell      => $shell,
        uid        => $uid,
        managehome => true,
        groups     => $groups
    }

    group { $username:
        gid     => $uid,
        require => USER[$username]
    }

    file {
        "/home/${username}/":
            ensure  => directory,
            owner   => $username,
            group   => $username,
            mode    => '0755',
            require => [ USER[$username], GROUP[$username] ];


        "/home/${username}/.ssh":
            ensure  => directory,
            owner   => $username,
            group   => $username,
            mode    => '0700',
            require => FILE["/home/${username}/"];

        "/home/${username}/.ssh/authorized_keys":
            ensure  => present,
            owner   => $username,
            group   => $username,
            mode    => '0600',
            require =>FILE["/home/${username}/"]
    }

    if ($sshkey != undef and $sshkeytype != undef) {
        ssh_authorized_key{ $username:
            ensure  => present,
            user    => $username,
            type    => $sshkeytype,
            key     => $sshkey,
            name    => $username,
            require => FILE["/home/${username}/.ssh/authorized_keys"]
        }
    }
}
