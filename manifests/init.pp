# == Class: misc::docker
#
class role_geneious (
  $compose_version     = '1.19.0',
  $docker_base_dir     = '/opt/docker-geneious',
  $docker_repo_source  = 'https://github.com/naturalis/docker-geneious.git',
  $env_file            = 'MYSQL_ROOT_PASSWORD=mypass'
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

  # Start containers
  docker_compose { "${role_geneious::docker_base_dir}/docker-compose.yml":
    ensure  => present,
    require => [
      Vcsrepo[$role_geneious::docker_base_dir]
    ]
  }

}
