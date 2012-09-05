
# install a rabbitmq server and add it to a cluster.

class rabbitmqcluster($cluster_nodes) {
    # this is needed because rabbitmq will always create a disk node if
    # there are no server in it's config to cluster with. If what we needed was
    # a ramnode that is problematic because converting a disk node into a ram node is
    # not trivial.
    include disablestart
    class {"rabbitmqcluster::cluster":
        cluster_nodes => $cluster_nodes,
    }
    
    # always create resource rabbitmqcluster::disablestart before 
    # rabbitmqcluster::cluster
    Class["disablestart"] -> Class["rabbitmqcluster::cluster"]
}
