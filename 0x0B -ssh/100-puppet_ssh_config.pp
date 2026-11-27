# Enforce secure SSH client configuration for the local user.

$ssh_directory = '/home/travis/.ssh'
$ssh_config = "${ssh_directory}/config"

file { $ssh_directory:
  ensure => directory,
  owner  => 'travis',
  group  => 'travis',
  mode   => '0700'
}

file { $ssh_config:
  ensure => file,
  owner  => 'travis',
  group  => 'travis',
  mode   => '0600',
  content => "Host 144.217.6.26\n IdentityFile ~/.ssh/school\n IdentitiesOnly yes\n PassowrdAuthentication no\n",
  require => File[$ssh_directory],
}
