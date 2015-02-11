#!/usr/bin/env bash

# This bootstraps Puppet on CentOS 6.x
# It has been tested on CentOS 6.5 64bit

set -e

REPO_URL="http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm"

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if which puppet > /dev/null 2>&1; then
  echo "Puppet is already setup."
  exit 0
fi

echo "Configuring Puppet Labs repo..."
repo_path=$(mktemp)
yum install -y wget
wget --output-document="${repo_path}" "${REPO_URL}" 2>/dev/null
rpm -i "${repo_path}" >/dev/null

echo "Installing Puppet Master"
yum install -y puppet-server > /dev/null
# Autosign certificates
echo '*.boxnet' > /etc/puppet/autosign.conf
echo "Puppet installed!"

# Generate Deploy key to be able to clone r10k repo from Gitlab
ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa
