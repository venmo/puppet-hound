# == Class: hound::config
#
# Generate various hound configs
#
class hound::config {

  $version     = $hound::version
  $package_dir = $hound::package_dir
  $bin_dir     = $hound::bin_dir
  $conf_dir    = $hound::conf_dir
  $user        = $hound::user
  $group       = $hound::group
  $host        = $hound::host
  $port        = $hound::port

  # hound config
  file { $conf_dir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  # If managed config, use params passed for config
  if $hound::managed_config {

    $hound_config_default = {
      'max-concurrent-indexers' => $hound::max_concurrent_indexers,
      'dbpath'                  => $hound::data_dir,
    }

    $hound_config = deep_merge($hound_config_default, $hound::repos)
    
    file { "${conf_dir}/config.json":
      ensure  => present,
      content => template('hound/config.json.erb'),
      owner   => $user,
      group   => $group,
      mode    => '0644',
      require => File[$hound::conf_dir],
    }

  # If config is UNmanaged, config.json needs to be generated
  # by an external script
  } else {

    # When the external script generates config.json,
    # it can also echo something other than 0 into
    # houndd_restart file and the next time puppet
    # runs hound will be restarted.
    file { "${hound::tmp_dir}/houndd_restart":
      ensure  => present,
      content => 0,
      owner   => $user,
      group   => $group,
      mode    => '0660',
    }

  }

  # init config
  case $hound::init_type {
    'sysv': {
      file { '/etc/init.d/houndd':
        mode    => '0555',
        owner   => 'root',
        group   => 'root',
        content => template('hound/houndd.sysv.erb'),
      }
    }
    'systemd': {
      file { '/lib/systemd/system/houndd.service':
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => template('hound/houndd.systemd.erb'),
      }
    }
    default: {
      fail("Unsupported init type ${hound::init_type}")
    }
  }

}
