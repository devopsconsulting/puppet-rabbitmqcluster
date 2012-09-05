
# set up the required exchanges in rabbitmq.
hostclass :"rabbitmqcluster::exchangesetup", :arguments => {
    "cluster_nodes" => nil
  } do
  # retrieve a server we can connect with, it really isn't important which one,
  # as long as it's a disk node.
  rabbitserver = scope.lookupvar('cluster_nodes').last
  
  # install the rabbitmqmonitor package which can also be used to create
  # exchanges.
  package "python-oe.rabbitmqmonitor",
    :ensure => "latest"
  
  if not rabbitserver.nil?
    fqdn = rabbitserver['fqdn']
    
    # run the rabbitsetup script which knows what exchanges should be created.
    create_resource :exec, "rabbitsetup",
    :command => "/usr/bin/rabbitsetup -p 5672 -H #{fqdn}",
      :subscribe => "Class[rabbitmq::service]",
      :require => "Package[python-oe.rabbitmqmonitor]",
      :refreshonly => true
  end
end
