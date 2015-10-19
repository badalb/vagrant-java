Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/bin']
}

include git
include jdk_oracle
#include archive::prerequisites


# --- Preinstall Stage ---#

stage { 'preinstall':
  before => Stage['main']
}

# Define the install_packages class
class install_packages {
  package { ['g++', 'make', 'mc', 'htop']:
    ensure => present
  }
}

# Declare (invoke) install_packages
class { 'install_packages':
  stage => preinstall
}

# Setup your locale to avoid warnings
file { '/etc/default/locale':
  content => "LANG=\"en_US.UTF-8\"\nLC_ALL=\"en_US.UTF-8\"\n"
}


# --- MySQL --- #

class { '::mysql::server':
 #root_password => 'foo'
}

#---- Memcached ---#
class { 'memcached': }

#---- Redis ----#
class { 'redis':
}

#--- Gradle ----#
class { "archive::prerequisites": } -> class { "gradle": version => "2.7" }


#class { 'eclipse':
#}
