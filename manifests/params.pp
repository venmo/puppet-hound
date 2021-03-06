# == Class: hound::params
#
# Default parameters,
# DO NOT call this class directly.
#
class hound::params {

  $version                 = '0.2.0'
  $package_url             = 'https://github.com/venmo/puppet-hound/releases/download/packages/0.2.0_linux_amd64.tar.gz'
  $package_dir             = '/opt/hound'
  $bin_dir                 = '/usr/local/bin'
  $conf_dir                = '/etc/hound'
  $data_dir                = '/var/cache/hound'
  $tmp_dir                 = '/tmp'
  $user                    = 'hound'
  $group                   = 'hound'
  $host                    = 'localhost'
  $port                    = 6080
  $init_type               = 'sysv'
  $managed_config          = true
  $max_concurrent_indexers = $::processorcount

  $repos = {
    'repos' => {
      'sentry' => {
        'url' => 'https://github.com/venmo/puppet-sentry.git',
      }, 
      'consulr' => {
        'url' => 'https://github.com/venmo/puppet-consulr.git',
      }, 
    },
  }
  
}
