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

  class { 'dev::nginx':
    username => $username,
    group    => $group,
  }
  include dev::mysql
  include dev::postgresql
  include dev::dotfiles
  include dev::sshsetup
  include dev::heroku
  include dev::memcachedsetup
  include dev::rubysetup
  include phantomjs
  # include dev::weighttp
  class { 'firewall': ensure => 'stopped'}

}
