
node default {
  Yumrepo['epel','jpackage'] ->
  Class['ntp'] ->

  exec {'disable-firewall':
    command => 'lokkit --disabled',
    path    => '/usr/sbin:/usr/bin'
  }

  yumrepo { 'epel':
    descr          => ' Extra Packages for Enterprise Linux 6 - $basearch',
    mirrorlist     => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
    failovermethod => 'priority',
    enabled        => $enabled,
    gpgcheck       => $enabled,
    gpgkey         => 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6',
  }
  yumrepo { 'jpackage':
    descr      => 'JPackage 6 generic',
    baseurl    => 'http://jenkins.telefonicadev.com:9393/jpackage/noarch',
    enabled    => $enabled,
    gpgcheck   => $enabled,
    gpgkey     => 'http://www.jpackage.org/jpackage.asc'
  }
  yumrepo { 'logstash':
    descr    => 'Logstash RPM Packages',
    baseurl  => 'http://logstash.objects.dreamhost.com/builds/rpms',
    enabled  => $enabled,
    gpgcheck => '0',
  }
  include ntp
  class { 'logstash': }
}
