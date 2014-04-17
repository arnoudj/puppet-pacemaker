# == Class: pacemaker
#
# Install and manage corosync and pacemaker.
#
# === Parameters
#
# [*bindnetaddr*]
#   This specifies the network address the corosync executive should bind to.
#   Default value is the IP address of the first ethernet device.
#
# [*mcastaddr*]
#   This is the multicast address used by corosync executive.
#   Default value is '226.94.1.1'.
#
# [*mcastport*]
#   This specifies the UDP port number.
#   Default value is 5405.
#
# [*multicast*]
#   Specifies whether to use multicast or unicast as the transport mechanism.
#   When set to false, Corosync will be configured for unicast. For the
#   unicast configuration exported resources are used.
#   Default value is 'true'.
#
# [*members*]
#   IP addresses of the nodes in the cluster. Only used when unicast is used
#   as the transport mechanism (multicast set to false).
#   Default value is [].
#
# [*options*]
#   Options to be passed to pacemaker.
#   default value is {}.
#
# === Examples
#
#  class { pacemaker:
#    bindnetaddr => $ipaddress_eth1
#    options     => {
#      stonith-enable => { value => 'false' }
#    }
#  }
#
# === Authors
#
# Arnoud de Jonge <arnoud.dejonge@cyso.com>
#
# === Copyright
#
# Copyright 2014 Cyso.
#
class pacemaker (
  $bindnetaddr = $ipaddress,
  $mcastaddr   = '226.94.1.1',
  $mcastport   = 5405,
  $multicast   = true,
  $members     = [],
  $options     = {},
) inherits ::pacemaker::params
{
  package { 'corosync':
    ensure  => 'installed',
    name    => $pacemaker::params::corosync_package,
  }
  ->
  file { '/etc/corosync/xml':
    ensure  => 'directory'
  }
  ->
  file { 'corosync.conf':
    path    => $pacemaker::params::corosync_conf_path,
    content => template('pacemaker/corosync.conf.erb'),
  }
  ~>
  service { 'corosync':
    ensure  => 'running',
    enable  => true,
    name    => $pacemaker::params::corosync_service,
  }

  if $::osfamily == debian {
    file { '/etc/default/corosync':
      content => 'START=yes',
      notify  => Service['corosync'],
      require => Package['corosync'],
    }
  }

  package { 'pacemaker':
    ensure  => 'installed',
    name    => $pacemaker::params::pacemaker_package,
  }

  create_resources(::pacemaker::option, $options)
}
