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
  $docker_repo_dir     = '/opt/docker-geneious',
  $docker_repo_source  = 'https://github.com/naturalis/docker-geneious.git'
  $mysql_version       = '5.5.60',
  $mysql_root_password = 'changeme',
  $mysql_database      = 'naturalis-geneious'
  ) {

  # Install docker
  class {'docker':
  }

  # Install docker compose
  class {'docker::compose':
    version => $::compose_version
  }

  # Download docker repo
  vcsrepo { $::docker_repo_dir:
    ensure   => present,
    provider => git,
    source   => $::docker_repo_source,
    #require  => Package['git'],
  }

  # Replace .env file
  file { "${::repo_dir}/.env":
    ensure   => file,
    content  => template('role_dockertreebase/prod.env.erb'),
    require  => Vcsrepo[$::docker_repo_dir],
    #notify   => Exec['Restart containers on change'],
  }

  # Start containers
  docker_compose { "{$::repo_dir}/docker-compose.yml":
    ensure  => present,
    require => [
      Vcsrepo[$::docker_repo_dir]
    ]
  }

}
