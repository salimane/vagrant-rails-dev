#!/bin/sh
rpm -qa puppetlabs-release | grep 'puppetlabs-release-6' || rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
rpm -qa epel-release | grep 'epel-release-6' || rpm -ivh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -qa remi-release | grep 'remi-release-6' || rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -qa ruby-devel | grep 'ruby-devel-1.8.7' || yum -y install ruby-devel
rpm -qa ruby-augeas | grep 'ruby-augeas-0.4.1' || yum -y install ruby-augeas-0.4.1
rpm -qa ruby-json | grep 'ruby-json-1.5.5' || yum -y install ruby-json-1.5.5
rpm -qa puppet | grep 'puppet-3.7.3' || yum -y install puppet-3.7.3
rpm -qa augeas-libs | grep 'augeas-libs-1.0.0' || yum -y install augeas-libs-1.0.0
rpm -qa augeas-devel | grep 'augeas-devel-1.0.0' || yum -y install augeas-devel-1.0.0
rpm -qa augeas | grep 'augeas-1.0.0' || yum -y install augeas-1.0.0
gem list | grep 'puppet.*3.7.3' || gem install puppet -v3.7.3
gem list | grep 'ruby-augeas.*0.5.0' || gem install ruby-augeas -v0.5.0
yum update -y
