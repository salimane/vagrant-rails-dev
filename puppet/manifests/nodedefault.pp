# == Class: nodedefault
#
class nodedefault {

    import 'timezone.pp'
    import 'adduser.pp'
    import 'puppetsetup.pp'
    import 'sshsetup.pp'
    import 'dotfiles.pp'
    import 'nginxsetup.pp'
    import 'mysqlsetup.pp'
    import 'postgresql.pp'
    import 'railssetup.pp'
    import 'redissetup.pp'
    import 'sysctlsetup.pp'
    import 'heroku.pp'
    import 'weighttp'
    import 'security'
    import 'memcachedsetup'

    include apt
    include timezone
    include puppetsetup
    include sshsetup
    include nginxsetup
    include mysqlsetup
    include redissetup
    include sysctlsetup
    include heroku
    include monit
    include security
    include memcachedsetup

}