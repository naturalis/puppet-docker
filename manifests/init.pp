# Class: role_geneious
# ===========================
#
# Full description of class role_geneious here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'role_geneious':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2018 Your name here, unless otherwise noted.
#
class role_geneious (
  $compose_version     = '1.19.0',
  $MYSQL_VERSION       = '5.5.60',
  $MYSQL_ROOT_PASSWORD = 'changeme',
  $MYSQL_DATABASE      = 'naturalis-geneious'
  ) {

  # Install docker
  class {'docker':
  }

  # Install docker compose
  class {'docker::compose':
    version => $role_geneious::compose_version
  }

  # Download docker repo
  vcsrepo { '/opt/docker-geneious':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/naturalis/docker-geneious.git'
    #require  => Package['git'],
  }

  # Start containers
  docker_compose { "/opt/docker-geneious/docker-compose.yml":
    ensure  => present,
    require => [
      Vcsrepo['/opt/docker-geneious']
    ]
  }

}
