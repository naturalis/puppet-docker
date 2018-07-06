# == Class: role_geneious
#
class role_geneious (
  $compose_version      = undef,
  $docker_base_dir      = undef,
  $docker_repo_source   = undef,
  $docker_repo_revision = undef,
  $env_file             = undef
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
    revision => $role_geneious::docker_repo_revision
    #require  => Package['git']
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
      Class['docker'],
      Class['docker::compose'],
      Vcsrepo[$role_geneious::docker_base_dir],
      File["${role_geneious::docker_base_dir}/.env"]
    ]
  }

}
