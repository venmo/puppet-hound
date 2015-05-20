# Class hound::install
class hound::install {

  user { $hound::user:
    ensure => present,
  } ->
  group { $hound::group:
    ensure => present;
  } ->

  file { $hound::package_dir:
    ensure => 'directory',
    owner  => $hound::user,
    group  => $hound::group,
    mode   => '0755',
  } ->
  file { $hound::data_dir:
    ensure => 'directory',
    owner  => $hound::user,
    group  => $hound::group,
    mode   => '0755',
  } ->

  staging::deploy { "hound_${hound::version}.tar.gz":
    source  => $hound::package_url,
    target  => $hound::package_dir,
    creates => "${hound::package_dir}/version_${hound::version}",
    user    => $hound::user,
    group   => $hound::group,
  } ->
  file { "${hound::bin_dir}/houndd":
    ensure => symlink,
    target => "${hound::package_dir}/houndd",
  }

  

}
