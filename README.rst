puppet-rabbitmqcluster: setup rabbitmqclusters with ease
========================================================

rabbitmqcluser requires puppet-rabbitmq.

The next requirement is that the puppet-role is defined as a fact. This
role should either be ``rabbitmqdisknode`` or ``rabbitmqramnode``.

If you are using puppet-kicker with cloudstack that is automatically the case. If
not, here's one way to do it::

    export FACTER_role='rabbitmadisknode'

facter will treat anvironment variables of the form ``FACTER_`` as facts and
will make them availble to puppet automatically.

After that it is just a matter of::

    $cluster_nodes = [{
        hostname => 'foohost',
        fqdn => 'foohost.example.com'
    }, {
        hostname => 'barhost',
        fqdn => 'barhost.example.com
    }]

    class {"rabbitmqcluster":
        cluster_nodes => $cluster_nodes
    }

Since the ``cluster_nodes`` parameter requires a list of hashes, you could also get the
``cluster_nodes`` using ``servers_with_role``::

    class {"rabbitmqcluster":
        cluster_nodes => servers_with_role('rabbitmqdisknode')
    }

    