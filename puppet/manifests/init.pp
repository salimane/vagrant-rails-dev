Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
File {
    owner => 0,
    group => 0,
    mode => 0644
}
Package{ensure => installed}

stage { 'first': }
stage { 'last': }
Stage['first'] -> Stage['main'] -> Stage['last']

import 'sysupdate.pp'
import 'nodes.pp'

class{'sysupdate':
  stage => first
}
