# Needed to kick start Vagrant with this out-of-band manifest

node default {
  class { '::r10k': }
  class { '::hiera': }
  create_resources(ini_setting, hiera('ini_settings'))
  create_resources(sshkey, hiera('ssh_keys'))
  create_resources(git_deploy_key, hiera('git_deploy_keys'))

  # Basic Autosigning of certificates

  file { '/etc/puppet/autosign.conf':
    content => '*.boxnet',
  }

  # Hack below to start puppetmaster daemon. Receiving an error:
  #
  # puppet-master: (/File[/etc/puppet/environments/production]/ensure)
  # change from absent to directory failed: Could not set 'directory' on ensure:
  # Permission denied - /etc/puppet/environments/production

  file { 'environment':
    path   => '/etc/puppet/environments/production',
    ensure => directory,
  }
  service { 'puppetmaster':
    enable  => true,
    ensure  => running,
    require => File['environment'],
  }
}
