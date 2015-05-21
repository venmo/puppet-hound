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
    $hound::init_type,
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

  # Ensure proper init type is being used
  if $::operatingsystem == 'Ubuntu' {
    $supported_init = 'sysv'
  } elsif $::operatingsystem =~ /Scientific|CentOS|RedHat|OracleLinux/ {
    if versioncmp($::operatingsystemrelease, '7.0') < 0 {
      $supported_init = 'sysv'
    } else {
      $supported_init  = 'systemd'
    }
  } elsif $::operatingsystem == 'Fedora' {
    if versioncmp($::operatingsystemrelease, '12') < 0 {
      $supported_init = 'sysv'
    } else {
      $supported_init = 'systemd'
    }
  } elsif $::operatingsystem == 'Debian' {
    if versioncmp($::operatingsystemrelease, '8.0') < 0 {
      $supported_init = 'sysv'
    } else {
      $supported_init = 'systemd'
    }
  } elsif $::operatingsystem == 'Amazon' {
    $supported_init = 'sysv'
  } else {
    $supported_init = false
  }

  if $hound::init_type != $supported_init {
    fail("Init type ${hound::init_type} is not \
    supported on ${::operatingsystem} ${::operatingsystemrelease}")
  }

  # Supported kernel archs
  if $::architecture !~ /x86_64|amd64/ {
    fail("Unsupported kernel arch: ${::architecture}")
  }
}
