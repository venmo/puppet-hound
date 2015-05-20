# == Class: hound::sanity
#
# Do some sanity checks
#
class hound::sanity {

  validate_string(
    $hound::version,
    $hound::package_url,
    $hound::user,
    $hound::group,
    $hound::host,
  )

  validate_absolute_path(
    $hound::package_dir,
    $hound::bin_dir,
    $hound::conf_dir,
    $hound::data_dir,
    $hound::tmp_dir,
  )

  validate_integer([
    $hound::port,
    $hound::max_concurrent_indexers,
  ])

  validate_bool(
    $hound::managed_config,
  )

  validate_hash(
    $hound::repos,
  )

  # Supported package types
  validate_re(
    $hound::package_url,
    [
      '.tar.gz$',
    ],
  )

}
