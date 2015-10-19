#!/usr/bin/env bash

set -o errtrace
set -o errexit


facter_version=2.4.4
puppet_version=3.8.3
target_volume=/Volumes/Macintosh\ HD

echo "About to install Facter $facter_version and Puppet $puppet_version on target volume $target_volume"

start_date=$(date "+%Y-%m-%d%:%H:%M:%S")

echo "mkdir  /private/tmp/$start_date ; cd /private/tmp/$start_date"
mkdir  /private/tmp/$start_date ; cd /private/tmp/$start_date

echo "curl -O http://downloads.puppetlabs.com/mac/facter-$facter_version.dmg"
curl -O http://downloads.puppetlabs.com/mac/facter-$facter_version.dmg
echo "curl -O http://downloads.puppetlabs.com/mac/puppet-$puppet_version.dmg"
curl -O http://downloads.puppetlabs.com/mac/puppet-$puppet_version.dmg

echo "hdiutil attach facter-$facter_version.dmg"
hdiutil attach facter-$facter_version.dmg
echo "hdiutil attach puppet-$puppet_version.dmg"
hdiutil attach puppet-$puppet_version.dmg


echo "sudo installer -package /Volumes/facter-$facter_version/facter-$facter_version.pkg -target $target_volume"
sudo installer -package /Volumes/facter-$facter_version/facter-$facter_version.pkg -target "$target_volume"

echo "sudo installer -package /Volumes/puppet-$puppet_version/puppet-$puppet_version.pkg -target $target_volume"
sudo installer -package /Volumes/puppet-$puppet_version/puppet-$puppet_version.pkg -target "$target_volume"

echo "Creating directories in /var and /etc - needs sudo"
sudo mkdir -p /var/lib/puppet
sudo mkdir -p /etc/puppet/manifests
sudo mkdir -p /etc/puppet/ssl



if [ $(dscl . -list /Groups | grep puppet | wc -l)  = 0 ]; then
  echo "Creating a puppet group - needs sudo"
  max_gid=$(dscl . -list /Groups gid | awk '{print $2}' | sort -ug | tail -1) 
  new_gid=$((max_gid+1))
  sudo dscl . create /Groups/puppet
  sudo dscl . create /Groups/puppet gid $new_gid
fi


if [ $(dscl . -list /Users | grep puppet | wc -l)  = 0 ]; then
  echo "Creating a puppet user - needs sudo"
  max_uid=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
  new_uid=$((max_uid+1))
  sudo dscl . create /Users/puppet
  sudo dscl . create /Users/puppet UniqueID $new_uid
  sudo dscl . -create /Users/puppet PrimaryGroupID $new_gid
fi

echo "Creating /etc/puppet/puppet.conf - needs sudo"

sudo sh -c "echo \"[main]
pluginsync = false
server = `hostname`
[master]
vardir = /var/lib/puppet
libdir = $vardir/lib
ssldir = /etc/puppet/ssl
certname = `hostname`
[agent]
vardir = /var/lib/puppet
libdir = $vardir/lib
ssldir = /etc/puppet/ssl
certname = `hostname`
\" > /etc/puppet/puppet.conf"

echo "Changing permissions - needs sudo"

sudo chown -R puppet:puppet  /var/lib/puppet
sudo chown -R puppet:puppet  /etc/puppet

echo "Cleaning up"

hdiutil detach /Volumes/facter-$facter_version
hdiutil detach /Volumes/puppet-$puppet_version

cd /private/tmp
rm -rf ./$start_date