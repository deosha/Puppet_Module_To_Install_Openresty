
#Puppet Module to install Openresty
#Author: Deo Shankar
#Date: 10th November, 2016
#Version 1.0
#OS: Ubuntu 14.04. yum is valid on redhat instead of apt and #package names as well
#Openresty Version 1.11.2.1



exec { 'apt-get-update':  
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
}

$packages = ["libreadline-dev", "libncurses5-dev", "libpcre3-dev", "libssl-dev", "perl", "make", "build-essential"]
package {  
    $packages: ensure => installed,
    require    => Exec['apt-get-update'],
}

#Download the openresty tar package

exec {"apps_wget":
            command => "/usr/bin/wget https://openresty.org/download/openresty-1.11.2.1.tar.gz",
    }

file { '/home/ubuntu/openresty-1.11.2.1.tar.gz':
	ensure  => present,
}

#Unpack the tar

exec { 'unpack-tar':
cwd => '/home/ubuntu',
command => '/bin/tar -zxf openresty-1.11.2.1.tar.gz',
}

#Install Openresty with partlicular modules only: http_ssl, pcre and pcre-jit in this case

exec { 'install-openresty':
             require => Exec['unpack-tar'],
	     cwd => '/home/ubuntu/openresty-1.11.2.1',
	     path    => ['/home/ubuntu/openresty-1.11.2.1','/usr/bin','/bin','/sbin'],
	     command => './configure --with-http_ssl_module --with-pcre --with-pcre-jit --with-luajit',
}


exec { 'make':
             require => Exec['install-openresty'],
             cwd => '/home/ubuntu/openresty-1.11.2.1',
             path => ['/home/ubuntu/openresty-1.11.2.1','/usr/bin','/bin','/sbin'],
	     command => 'sudo make',
	} 

exec { 'make-install':  
        require => Exec['make'],
	cwd => '/home/ubuntu/openresty-1.11.2.1',
        path => ['/home/ubuntu/openresty-1.11.2.1','/usr/bin','/bin','/sbin'],
        command => 'sudo make install',
        }		

