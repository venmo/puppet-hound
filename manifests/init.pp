# Class hound
class hound (

  $version = $hound::params::version,
  
  $package_url = $hound::params::package_url,
  
  $package_dir = $hound::params::package_dir,
  
  $bin_dir  = $hound::params::bin_dir,
  $conf_dir = $hound::params::conf_dir,
  $data_dir = $hound::params::data_dir,
  $tmp_dir  = $hound::params::tmp_dir,
  
  $user  = $hound::params::user,
  $group = $hound::params::group,
  
  $host = $hound::params::host,
  $port = $hound::params::port,

  $managed_config          = $hound::params::managed_config,
  $max_concurrent_indexers = $hound::params::max_concurrent_indexers,
  $repos                   = $hound::params::repos,
) inherits hound::params {

  anchor { 'hound::begin': } ->
  class { 'hound::install': } ->
  class { 'hound::config': } ~>
  class { 'hound::service': } ->
  anchor { 'hound::end': }

}
