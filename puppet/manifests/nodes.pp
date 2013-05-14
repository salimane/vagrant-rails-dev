
node default {

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
    #import 'heroku.pp'
    import 'weighttp'
    import 'security'
    import 'memcachedsetup'

    # add user vagrant
    adduser { 'vagrant':
        shell      => '/bin/zsh',
        groups     => ['sudo'],
        sshkeytype => 'ssh-rsa',
        sshkey     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDT2yEfwTAsvOqWCzCas/JmIjuVvMtVN+1g/ZRpdxNvyTep9kYLodcKOMg77RpiqDGdhJVH3XpXbfWE8zGihc1CN1KymhO5L3WhlaAsViDYqirrMPtlOwO897sCmF8TfL7aPWGU4RBQKUv9DfdBzHUaDBOufZZS6bgtMCzqoiWM5n0kjOpZ9imX+53kZJ288wGrF/GahFe17y+q5n0D8If6kZ2mMUjBVW6oCYlLWE0HEZaZt+1R4no1P3keiZ2hn9DIhKytJivrI9aQdAymzpAtRiykzErTGhO6ZK0n9ukXMb9sqWL+4pbCvERs6BRetmVvIb6zT4mpy0xhjhpy8uzH'
    }

    class { 'apt': }
    include timezone
    include puppetsetup
    include sshsetup
    include dotfiles
    include nginxsetup
    include mysqlsetup
    include railssetup
    include redissetup
    include sysctlsetup
    #include heroku
    #include monit
    include weighttp
    include security
    include memcachedsetup
}
