# == Class: misc::docker
#
class role_geneious (
  $compose_version     = '1.19.0',
  $docker_repo_dir     = '/opt/docker-geneious',
  $docker_repo_source  = 'https://github.com/naturalis/docker-geneious.git'
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
