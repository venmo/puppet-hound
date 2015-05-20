# Class hound::service
#
#
#
class hound::service {

  service { 'houndd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }

}
