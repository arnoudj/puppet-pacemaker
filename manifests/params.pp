# == Class: pacemaker::params
#
# Parameters for corosync and pacemaker.
#
# === Authors
#
# Arnoud de Jonge <arnoud.dejonge@cyso.com>
#
# === Copyright
#
# Copyright 2014 Arnoud de Jonge, unless otherwise noted.
#
class pacemaker::params {
  if $::osfamily == 'RedHat' {
    $corosync_package = 'corosync'
    $pacemaker_package = 'pacemaker'
  } elsif $::osfamily == 'Debian' {
    $corosync_package = 'corosync'
    $pacemaker_package = 'pacemaker'
  }
}
