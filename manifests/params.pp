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
# Copyright 2014 Cyso.
#
class pacemaker::params {
  if $::osfamily == 'RedHat' {
    $corosync_package = 'corosync'
    $pacemaker_package = 'pacemaker'
    $corosync_conf_path = '/etc/corosync/corosync.conf'
  } elsif $::osfamily == 'Debian' {
    $corosync_package = 'corosync'
    $pacemaker_package = 'pacemaker'
    $corosync_conf_path = '/etc/corosync/corosync.conf'
  }
}
