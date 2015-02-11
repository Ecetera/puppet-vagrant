# Needed to kick start Vagrant with this out-of-band manifest

node default {
  class { '::r10k': }
  class { '::hiera': }
  create_resources(service, hiera('enable_puppet'))
  create_resources(ini_setting, hiera('settings'))
  create_resources(sshkey, hiera('ssh_keys'))
  create_resources(git_deploy_key, hiera('deploy_keys'))
}
