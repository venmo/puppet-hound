# == Class: hound::config
#
# Generate various hound configs
#
class hound::config {

  # hound config
  file { $hound::conf_dir:
    ensure => directory,
    owner  => $hound::user,
    group  => $hound::group,
    mode   => '0755',
  }

  # If managed config, use params passed for config
  if $hound::managed_config {

    $hound_config_default = {
      'max-concurrent-indexers' => $hound::max_concurrent_indexers,
      'dbpath'                  => $hound::data_dir,
    }

    $hound_config = merge($hound_config_default, $hound::repos)
    
    file { "${hound::conf_dir}/config.json":
      ensure  => present,
      content => template('hound/config.json.erb'),
      owner   => $hound::user,
      group   => $hound::group,
      mode    => '0644',
      require => File[$hound::conf_dir],
    }

  # If config is UNmanaged, it means some external script
  # which puppet has no control over is generating config.json
  } else {

    # All we really care about is config.json, not the script
    # generating config.json.
    exec { 'check if config.json exists':
      command => '/bin/false',
      unless  => "/usr/bin/test -e ${hound::conf_dir}/config.json",
    } ->

    # This is a pretty neat feature. When the external script
    # generates config.json, it can also echo something other than
    # 0 into hound_restart file and the next time puppet runs hound
    # will be restarted.
    file { "${hound::tmp_dir}/hound_restart":
      ensure  => present,
      content => 0,
      owner   => $hound::user,
      group   => $hound::group,
      mode    => '0660',
    }

  }

  # init config
  case $::operatingsystem {
    'Ubuntu': {
      file { '/etc/init/houndd.conf':
        mode    => '0444',
        owner   => 'root',
        group   => 'root',
        content => template('hound/houndd.upstart.erb'),
      } ->
      file { '/etc/init.d/houndd':
        ensure => link,
        target => '/lib/init/upstart-job',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    }
    default: {
      fail("Unsupported OS ${::operatingsystem}")
    }
  }

}
