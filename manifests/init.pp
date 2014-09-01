class cmnginx {
  Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin" }

  class { 'cmnginx::package': }
}
