# @summary Setup the repository for proxysql
#
# @private
#
class proxysql::repo {

case $::lsbdistcodename {
    'xenial': {
      file { '/tmp/proxysql-rc2_2.0.0-ubuntu16_amd64.deb':
        ensure  => '/tmp/proxysql-rc2_2.0.0-ubuntu16_amd64.deb',
        source  => 'https://github.com/sysown/proxysql/releases/download/v2.0.0-rc2/proxysql-rc2_2.0.0-ubuntu16_amd64.deb',
        notify  => Package['ProxySQL-Xenial-Repo'],
      }

      package { 'ProxySQL-Xenial-Repo':
        provider  => dpkg,
        ensure    => latest,
        source    => '/tmp/proxysql-rc2_2.0.0-ubuntu16_amd64.deb',
        requires  => File['/tmp/proxysql-rc2_2.0.0-ubuntu16_amd64.deb'],
      }
    }

  case $facts['operatingsystem'] {
    'CentOS', 'OracleLinux', 'RedHat', 'Scientific': {
      yumrepo { 'proxysql':
        baseurl  => 'http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/centos/$releasever',
        descr    => 'ProxySQL YUM repository',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'http://repo.proxysql.com/ProxySQL/repo_pub_key',
      }
    }
    default: {
      fail("${facts['operatingsystem']} is not supported.")
    }
  }

}
