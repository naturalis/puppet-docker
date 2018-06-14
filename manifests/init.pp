# == Class: misc::docker
#
class role_geneious (
  $compose_version     = '1.19.0',
  $docker_base_dir     = '/opt/docker-geneious',
  $docker_repo_source  = 'https://github.com/naturalis/docker-geneious.git',
  $env_file            = undef
  ) {

  # Install docker
  class {'docker':
  }

  # Install docker compose
  class {'docker::compose':
    version => $role_geneious::compose_version
  }

  # Download docker repo
  vcsrepo { $role_geneious::docker_base_dir:
    ensure   => present,
    provider => git,
    source   => $role_geneious::docker_repo_source,
    #require  => Package['git'],
  }

  # Replace .env file
  file { "${role_geneious::docker_base_dir}/.env":
    ensure   => file,
    content  => $role_geneious::env_file,
    require  => Vcsrepo[$role_geneious::docker_base_dir],
    #notify   => Exec['Restart containers on change'],
  }

  # Exec defaults
  Exec {
    path => '/usr/local/bin/',
    cwd  => $role_geneious::docker_base_dir
  }

  # Start containers
  exec { 'Up the containers':
    command  => 'docker-compose up -d',
    require => [
      Vcsrepo[$role_geneious::docker_base_dir],
      Class['docker::compose']
    ]
  }

}
