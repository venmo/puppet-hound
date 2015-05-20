# ==  Class: hound
#
# Hound is an extremely fast source code search engine.
#
# === Parameters
#
# [*version*]
#   Version of hound to install
#   Upgrade or Downgrade is possible.
#
# [*package_url*]
#   Every path supported by nanliu/staging will
#   work here. Only tar.gz packages supported.
#
# [*package_dir*]
#   Directory where the package is extracted.
#   Every directory that follows after this can
#   be nested inside package_dir since package_dir
#   is a dependency for all of them.
#
# [*bin_dir*]
#   houndd binary directory
#
# [*conf_dir*]
#   config.json directory
#
# [*data_dir*]
#   repository indices storage location
#
# [*tmp_dir*]
#   tmp directory to store state info
#
# [*user*]
#   user to run the daemon as
#
# [*group*]
#   group to run the daemon as
#
# [*host*]
#   defaults to 127.0.0.1
#
# [*port*]
#   defaults to 6080
#
# [*managed_config*]
#   one of the coolest feature of this module
#   is the ability to NOT manage config.json.
#   If this is set to 'false', you will be
#   able to generate your own config.json.
#   More info about this in README.
#
# [*max_concurrent_indexers*]
#   Defaults to the number of processors available.
#   This option will only take effect if $managed_config
#   is 'true'
#
# [*repos*]
#   Add repos to index. See README for more info.
#   This option will only take effect if $managed_config
#   is 'true'
#
class hound (
  $version                 = $hound::params::version,
  $package_url             = $hound::params::package_url,
  $package_dir             = $hound::params::package_dir,
  $bin_dir                 = $hound::params::bin_dir,
  $conf_dir                = $hound::params::conf_dir,
  $data_dir                = $hound::params::data_dir,
  $tmp_dir                 = $hound::params::tmp_dir,
  $user                    = $hound::params::user,
  $group                   = $hound::params::group,
  $host                    = $hound::params::host,
  $port                    = $hound::params::port,
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
