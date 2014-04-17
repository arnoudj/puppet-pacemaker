## Define: pacemaker::option
#
# Set pacemaker options.
#
define pacemaker::option ( $value ) {
  exec { "crm_attribute --attr-name '${name}' --attr-value '${value}'":
    path    => '/sbin:/bin:/usr/sbin:/usr/bin',
    unless  => "test `crm_attribute --attr-name '${name}' --get-value | sed 's/.*value=//'` = '${value}'",
    require => Package['pacemaker'],
  }
}
