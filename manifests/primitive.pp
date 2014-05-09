# == Define: pacemaker::primitive
#
# Create a resource.
#
# === Parameters
#
# [*scriptclass*]
#   The standard the script conforms to. Allowed values: ocf, service, upstart, systemd, lsb, stonith.
#   Default value is lsb.
#
# [*provider*]
#   The OCF spec allows multiple vendors to supply the same ResourceAgent.
#   To use the OCF resource agents supplied with Heartbeat, you should
#   specify heartbeat here.
#
# [*type*]
#   The name of the Resource Agent you wish to use. Eg. IPaddr2 or Filesystem.
#
# [*targetrole*]
#   What state should the cluster attempt to keep this resource in? Allowed values:
#    * Stopped - Force the resource to be stopped
#    * Started - Allow the resource to be started (In the case of multi-state resources, they will not promoted to master)
#    * Master - Allow the resource to be started and, if appropriate, promoted
#   Default value is "Started".
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
# Copyright 2014 Cyso.
#

define pacemaker::primitive (
  $scriptclass = "ocf",
  $provider    = undef,
  $type,
  $targetrole  = "Started",
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
    command     => "cibadmin --replace --obj_type resources --xml-file /etc/corosync/xml/p_${name}.xml || (mv /etc/corosync/xml/p_${name}.xml /etc/corosync/xml/p_${name}.xml.failed; exit 1)",
    unless      => "cibadmin --create --obj_type resources --xml-file /etc/corosync/xml/p_${name}.xml 2>/dev/null",
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
    require     => Package['pacemaker'],
  }
}
