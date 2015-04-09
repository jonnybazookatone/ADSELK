# Some const. variables
$path_var = "/usr/bin:/usr/sbin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
$build_packages = ['wget']

# Update package list
exec {'apt_update_1':
	command => 'apt-get update && touch /etc/.apt-updated-by-puppet1',
	creates => '/etc/.apt-updated-by-puppet1',
	path => $path_var,
}

# Install packages
package {$build_packages:
	ensure => installed,
	require => Exec['apt_update_1'],
}

# Python path to work while on the VM
exec {'update_python_path':
    command => 'wget -qO- https://get.docker.com/ | sh',
    path => $path_var,
    require => Package[$build_packages],
}

Exec['apt_update_1'] -> Package[$build_packages] -> Exec['update_python_path']
