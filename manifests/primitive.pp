# == Define: pacemaker::primitive
#
# Create a resource.
#
# === Parameters
#
# [*class*]
# Specify the resource class. Supported are: ocf, lsb, upstart, systemd,
# fencing, service, nagios and stonith. Defaults to lsb.
#
# [*provider*]
# The OCF spec allows multiple vendors to supply the same ResourceAgent.
# To use the OCF resource agents supplied with Heartbeat, you should
# specify heartbeat here.
#
# [*type*]
# The name of the Resource Agent you wish to use. Eg. IPaddr or Filesystem.
#
# [*parameters*]
# [*operations*]
#
# === Variables
#
# === Examples
#
#   corosync::primitive { 'p_apache':
#     class       => 'lsb',
#     type        => 'apache',
#     operations  => {
#       'monitor' => { 'interval' => '10s', 'timeout' => '30s' },
#       'start'   => { 'interval' => '0', 'timeout' => '30s' }
#     }
#   }
#
#   corosync::primitive { 'p_vip':
#     class       => 'ocf',
#     type        => 'IPaddr2',
#     provider    => 'heartbeat',
#     parameters  => {
#       'ip' => '1.1.1.1', 'cidr_netmask' => '24'
#     },
#     operations  => {
#       'monitor' => { 'interval' => '10s', 'timeout' => '30s' },
#       'start'   => { 'interval' => '0', 'timeout' => '30s' }
#     }
#   }
#
# === Authors
#
# Arnoud de Jonge <arnoud.dejonge@cyso.com>
#
# === Copyright
#
# Copyright 2014 Arnoud de Jonge, unless otherwise noted.
#

define pacemaker::primitive (
  $class       = "ocf",
  $provider    = undef,
  $type,
  $parameters  = {},
  $operations  = {},
  $clone       = true,
  $cloneparams = {},
) {
  if $clone {
    $cname = $name
    $pname = "pr_${name}"
  }
  else {
    $pname = $name
  }

  file { "/etc/corosync/xml/p_${name}.xml":
    content => template("pacemaker/primitive.xml.erb"),
  }
  ~>
  exec { "load p_${name}.xml":
    command     => "cibadmin --modify --obj_type resources --xml-file /etc/corosync/xml/p_${name}.xml",
    unless      => "cibadmin --create --obj_type resources --xml-file /etc/corosync/xml/p_${name}.xml 2>/dev/null",
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
