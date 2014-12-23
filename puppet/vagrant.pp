# Needed to kick start Vagrant with this out-of-band manifest

node 'puppet.boxnet' {

  service { 'puppetmaster':
    ensure => 'running',
    enable => 'true',
  }
  Ini_setting {
    ensure => present,
    path   => "${::settings::confdir}/puppet.conf",
    notify => Service["puppetmaster"],
  }
  ini_setting { 'Configure environmentpath':
    section => 'main',
    setting => 'environmentpath',
    value   => '$confdir/environments',
  }
  file { '/etc/puppet/hiera.yaml':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    source => '/vagrant/puppet/hiera.yaml',
  }
  #  file { '/var/lib/puppet/reports':
  #    owner   => 'puppet',
  #    group   => 'puppet',
  #    recurse => true,
  #  }
  sshkey { "gitlab.services.ecetera.com.au":
    ensure => present,
    type   => "ssh-rsa",
    target => "/root/.ssh/known_hosts",
    key    => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDDLiWI5/lpx9/jUMAQ6MBYw2Iiwo6exujASxDNjH3wS+tFrEbNztkGnNJiFEXn3QT8OehtwRm6abE6APoqO98Xm5H+Wc/gqvxDUwEoN5rn/eTZgfE2NYRJ6/nlLf8D0KPtsSSGGUOpp9HF2EO42I3a6v1ppAQcyY1fwIjef5RXer4LliW4j0dfkJIocmzAeoXw9IIi+68vLVLCGB3MyekI206lN2zJbcsltGcsll5wX1PFvAz7okoFdd7DybwRIXAljT4e+u4l2t2Wp83+2/7f8PWskHUsATr7KkxHNAAv1gXKgGgmeTUrok7vZYDrE+FK+3ICEnuuCXwKOxDC2MZL",
  }
  git_deploy_key { 'add_deploy_key_to_puppet_control':
    ensure       => present,
    name         => $::fqdn,
    path         => '/root/.ssh/id_rsa.pub',
    token        => 'CEkvf9ZzFcdfSLPxkTsV',
    project_name => 'ecetera/puppet-control',
    server_url   => 'https://gitlab.services.ecetera.com.au',
    provider     => 'gitlab',
  }
  class { '::r10k':
    sources       => {
      'puppet'    => {
        'remote'  => 'git@gitlab.services.ecetera.com.au:ecetera/puppet-control.git',
        'basedir' => "${::settings::confdir}/environments",
        'prefix'  => false,
      }   
    },  
    #purgedirs         => ["${::settings::confdir}/environments"],
  }
}
