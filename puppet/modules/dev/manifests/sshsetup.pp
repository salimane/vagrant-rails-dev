# Definition: sshsetup
#
class  dev::sshsetup {

    file_line { 'rootlogin':
        path    => '/etc/ssh/sshd_config',
        line    => 'PermitRootLogin no',
        require => File['/etc/ssh/sshd_config']
    }
}
