class sysctlsetup {

    # modify number of file descriptors a user can open.
    augeas {'limits':
        context => '/files/etc/security/limits.conf',
        changes => [
        # remove existing file desciptor limit definition
        'rm domain[.=\'root\'][./item=\'nofile\']',
        # add definition for one million file desciptors
        'set domain[.=\'root\'] root',
        'set domain[.=\'root\']/type -',
        'set domain[.=\'root\']/item nofile',
        'set domain[.=\'root\']/value 1048576',
    ]
    }

    augeas { 'lotsofsockets':
        context => '/files/etc/sysctl.conf',
        changes => [
            # increase TCP max buffer size setable using setsockopt()
            # 16MB with a few parallel streams is recommended for most 10G paths
            # 32MB might be needed for some very long end-to-end 10G or 40G paths
            'set net.core.rmem_max 16777216',
            'set net.core.wmem_max 16777216',
            # increase Linux autotuning TCP buffer limits
            # min, default, and max number of bytes to use
            # (only change the 3rd value, and make it 16 MB or more)
            'set net.ipv4.tcp_rmem 4096 87380 16777216',
            'set net.ipv4.tcp_wmem 4096 65536 16777216',
            # recommended to increase this for 10G NICS
            'set net.core.netdev_max_backlog 30000',
            # these should be the default, but just to be sure
            'set net.ipv4.tcp_timestamps 1',
            'set net.ipv4.tcp_sack 1',
        # allow one million file descriptors per process.
            'set fs.file-max 1048576',
        ],
        notify => Exec['reload-sysctl'],
    }

    exec {'reload-sysctl':
        command     => '/sbin/sysctl -p',
        refreshonly => true,
    }

}