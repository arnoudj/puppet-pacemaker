# pacemaker

A module for installing and managing pacemaker. This module will install
Pacemaker with Corosync. No other configurations are supported.

## Example

    class { 'pacemaker': }

    pacemaker::primitive { 'vip':
      scriptclass => 'ocf',
      provider    => 'heartbeat',
      type        => 'ipaddr2',
      operations  => {
        'start'   => { 'interval' => '10s', 'timeout' => '30s', 'on-fail' => 'restart' },
        'monitor' => { 'interval' => '10s', 'timeout' => '30s' },
      },
      parameters  => {
        'ip'          => '192.168.1.66',
        'cid_netmask' => '24'
      },
      clone       => true,
      cloneparams => {
        'clone-max'       => '2',
        'globally_unique' => 'false',
        'interleave'      => 'false',
      }
    }

    pacemaker::primitive { 'apache':
      class       => 'lsb',
      type        => 'apache2',
      operations  => {
        'start'   => { 'interval' => '10s', 'timeout' => '30s', 'on-fail' => 'restart' },
        'monitor' => { 'interval' => '10s', 'timeout' => '30s' },
      },
      clone       => true,
      cloneparams => {
        'clone-max'       => '2',
        'globally_unique' => 'false',
        'interleave'      => 'false',
      }
    }
