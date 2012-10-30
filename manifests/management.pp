class rabbitmqcluster::management {
    rabbitmq_plugin {'rabbitmq_management':
      ensure => present,
      provider => 'rabbitmqplugins',
      notify => Service[rabbitmq-server]
    }
}
