# == Class: pacemaker
#
# Install and manage corosync and pacemaker.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { pacemaker: }
#
# === Authors
#
# Arnoud de Jonge <arnoud.dejonge@cyso.com>
#
# === Copyright
#
# Copyright 2014 Arnoud de Jonge, unless otherwise noted.
#
class pacemaker inherits ::pacemaker::params {
  package { "corosync":
    name   => $pacemaker::params::corosync_package,
    ensure => 'installed',
  }

  package { "pacemaker":
    name   => $pacemaker::params::pacemaker_package,
    ensure => 'installed',
  }

  file { '/etc/corosync/xml':
    ensure  => 'directory'
  }
}
