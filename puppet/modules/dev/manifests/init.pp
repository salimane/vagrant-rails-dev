# Module: dev
#
# A puppet module to setup a rails dev env  in vagrant-dev(http://github.com/salimane/vagrant-rails-dev.git)
#
# Salimane Adjao Moustapha <salimane.moustapha@meltwater.com>
#
# To set any of the following, simply set them as class parameters
# for example:
#
# class{'dev':
# }
#
class dev ($username = 'vagrant', $group = 'vagrant') {

  # dev::adduser { $username:
  #   shell      => '/bin/zsh',
  #   groups     => ['sudo'],
  #   sshkeytype => 'ssh-rsa',
  #   sshkey     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDT2yEfwTAsvOqWCzCas/JmIjuVvMtVN+1g/ZRpdxNvyTep9kYLodcKOMg77RpiqDGdhJVH3XpXbfWE8zGihc1CN1KymhO5L3WhlaAsViDYqirrMPtlOwO897sCmF8TfL7aPWGU4RBQKUv9DfdBzHUaDBOufZZS6bgtMCzqoiWM5n0kjOpZ9imX+53kZJ288wGrF/GahFe17y+q5n0D8If6kZ2mMUjBVW6oCYlLWE0HEZaZt+1R4no1P3keiZ2hn9DIhKytJivrI9aQdAymzpAtRiykzErTGhO6ZK0n9ukXMb9sqWL+4pbCvERs6BRetmVvIb6zT4mpy0xhjhpy8uzH'
  # }

  class { 'dev::web':
    username => $username,
    group    => $group,
  }
  class { 'dev::db': env => $env }
  class {'postgresql::client': }
  class {'postgresql::server': }
  include dev::dotfiles
  include dev::sshsetup
  include dev::heroku
  include dev::memcachedsetup
  include dev::rubysetup
  include dev::weighttp
  class { 'firewall': ensure => 'stopped'}

}
