
# A ruby manifest that will configure a rabbit mq server.
# The ruby manifest is the most powerfull way to create a
# manifest because all the power of ruby can be used.

hostclass :"rabbitmqcluster::cluster", :arguments => {
    "cluster_nodes" => nil
  } do

  # render the cluster config with the disk nodes.
  rabbitmq_config = template(['rabbitmqcluster/rabbitmqcluster.config.erb'])
  
  # Import rabbitmq::repo::apt into this scope and create one instance of it.
  # The rabbitmq apt repo contains the latest version of rabbitmq.
  scope.find_resource_type "rabbitmq::repo::apt"
  create_resource :class, "rabbitmq::repo::apt"
  
  # do not create RAM rabbit node if no disk nodes are available to cluster with.
  # this is because the server will be started as a disk node and can not
  # be restarted as a ram node without trouble. If a RAM disk was allready present,
  # creating a RAM node is fine.
  unless scope.lookupvar('cluster_nodes').empty? and scope.lookupvar('::role') == 'rabbitmqramnode'
    
    # install the rabbitmq server using the cluster config we previously generated.
    scope.find_resource_type "rabbitmq::server"
    create_resource :class, "rabbitmq::server",
      :version => "latest",
      :config => rabbitmq_config,
      :require => "Class[rabbitmq::repo::apt]"
    
    # connect all the rabbitmq servers with the same erlang cookie.
    file "/var/lib/rabbitmq/.erlang.cookie",
      :source => "puppet:///modules/rabbitmqcluster/var/lib/rabbitmq/dot.erlang.cookie",
      :replace => true,
      :require => "Class[rabbitmq::server]",
      :mode => '0400',
      :owner => 'rabbitmq',
      :group => 'rabbitmq'

    # kick lvs so new servers will be added to the load balancer pool immediately.
    create_resource :notify, "kick -> lvs"
  end
end
