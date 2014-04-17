# == Define: pacemaker::colocation
#
# Create a set of colocated resources. Putting resources into a colocation
# ensures they are started on the same node.
#
# === Parameters
#
# [*resources*]
#   The set of resources to add to the colocation.
#
# [*sequential*]
#   Specify whether or not the resources should be started in the order
#   specified in the resources array. When true, a failed resource will
#   result in the rest of the resources not being started. Then set to
#   true, no pacemaker::order should have to be specified.
#   Default value is true.
#
# [*score*]
#   By setting a score, you can specify how likely it is that resources
#   will be places on the same node. Setting score to 'INFINITY' (default)
#   resources in the colocation will always end up on the same node.
#   By setting score to '-INFINITY', the resources will always end up on
#   different hosts.
#
# === Examples
#
#   pacemaker::colocation { 'vip_with_apache':
#     resources => ['vip','apache'],
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

define pacemaker::colocation (
  $resources  = [],
  $sequential = true,
  $score      = "INFINITY",
) {
  file { "/etc/corosync/xml/c_${name}.xml":
    content => template("pacemaker/colocation.xml.erb"),
  }
  ~>
  exec { "load p_${name}.xml":
    command     => "cibadmin --replace --obj_type constraints --xml-file /etc/corosync/xml/c_${name}.xml || (rm /etc/corosync/xml/c_${name}.xml; exit 1)",
    unless      => "cibadmin --create --obj_type constraints --xml-file /etc/corosync/xml/c_${name}.xml 2>/dev/null",
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
