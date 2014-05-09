# == Define: pacemaker::order
#
# Create a resource.
#
# === Parameters
#
# [*first*]
#
# [*then*]
#
# [*score*]
#
# === Examples
#
#   corosync::order { 'vip_before_apache':
#     first  => 'vip',
#     then   => 'apache',
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

define pacemaker::order (
  $first,
  $then,
) {
  file { "/etc/corosync/xml/o_${name}.xml":
    content => template("pacemaker/order.xml.erb"),
  }
  ~>
  exec { "load p_${name}.xml":
    command     => "cibadmin --modify --obj_type constraints --xml-file /etc/corosync/xml/o_${name}.xml",
    unless      => "cibadmin --create --obj_type constraints --xml-file /etc/corosync/xml/o_${name}.xml 2>/dev/null",
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
    require     => Package['pacemaker'],
  }
}
