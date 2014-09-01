class cmnginx::package {

  if ! defined(Package['libpcre3-dev']) { package { 'libpcre3-dev': ensure => installed, } }
  if ! defined(Package['libssl-dev']) { package { 'libssl-dev': ensure => installed, } }
  if ! defined(Package['wget']) { package { 'wget': ensure => installed, } }

  exec { 'cmnginx::package::download_nginx':
    cwd     => '/tmp',
    command => "http://nginx.org/download/nginx-1.7.2.tar.gz -O nginx.tar.gz",
    creates => '/tmp/nginx.tar.gz',
    require  => [
      Package['wget'],
    ]
  }

  exec { 'cmnginx::package::download_httpecho':
    cwd     => '/tmp',
    command => "https://github.com/openresty/echo-nginx-module/archive/v0.54.tar.gz -O echo-nginx-module.tar.gz",
    creates => '/tmp/echo-nginx-module.tar.gz',
    require  => [
      Package['wget'],
    ]
  }

  exec { 'cmnginx::package::install_nginx':
    cwd     => '/tmp',
    command => "tar zxf nginx.tar.gz ; tar zxf echo-nginx-module.tar.gz; cd nginx* ; ./configure --add-module=../echo-nginx-module-0.54 ; make -j2 install",
    creates => '/usr/local/nginx',
    require  => [
      Package['libreadline-dev'],
      Package['libncurses5-dev'],
      Package['libpcre3-dev'],
      Package['libssl-dev'],
      Exec['cmnginx::package::download_nginx'],
      Exec['cmnginx::package::download_httpecho']
    ],
  }
}