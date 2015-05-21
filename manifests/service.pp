# == Class: hound::service
#
# Manage hound service
#
class hound::service {

  service { 'houndd':
    ensure    => running,
    enable    => true,
  }

}
