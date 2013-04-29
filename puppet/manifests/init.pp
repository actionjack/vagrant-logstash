
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
    baseurl    => 'http://mirrors.dotsrc.org/jpackage/6.0/generic/free/RPMS/',
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

  logstash::input::file { 'syslog':
      path         => ['/var/log/messages'],
      type         => 'syslog',
      tags         => ['syslog'],
      sincedb_path => '/var/log/logstash/.sincedb'
  }
  logstash::input::file { 'secure':
      path         => ['/var/log/secure'],
      type         => 'syslog',
      tags         => ['security'],
      sincedb_path => '/var/log/logstash/.sincedb'
  }
  logstash::input::file { 'tomcat':
      path         => ['/var/log/tomcat7/catalina.out*', '/var/log/tomcat7/localhost_access_log*'],
      type         => 'tomcat',
      tags         => ['tomcat'],
      sincedb_path => '/var/log/logstash/.sincedb'
  }

  logstash::output::amqp { 'shipper':
      host          => 'myamqpserver',
      exchange_type => 'fanout',
      exchange      => 'logs-exchange',
      vhost         => 'logs',
      user          => 'logs',
      password      => 'thegoodolesecurepaswordihave'
  }
}
