#!/usr/bin/env bash
#
# This bootstraps Puppet on Ubuntu 14.04 LTS.
#

# Load up the release information
. /etc/lsb-release

REPO_DEB_URL="http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb"

INSTALLED=$(dpkg -s puppetlabs-release 2>/dev/null|grep installed)
if [ $? == 0 ]; then
    echo "Puppet is already installed"
    exit 0
fi

echo "Configuring Puppet Labs repo..."
repo_deb_path=$(mktemp)
wget --output-document="${repo_deb_path}" "${REPO_DEB_URL}" 2>/dev/null
dpkg -i "${repo_deb_path}" >/dev/null
apt-get update >/dev/null

echo "Installing Puppet Master..."
apt-get install -y puppetmaster >/dev/null
puppet agent --enable
echo "Puppet installed and running."

# Generate Deploy key to be able to clone repos from Gitlab
ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa
