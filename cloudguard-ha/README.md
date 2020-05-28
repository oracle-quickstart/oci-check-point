# Check Point Security Gateway Cluster - BYOL

This quick start deploys two Check Point R80.40 Security Gateways to be configured as a HA cluster.

There are two options for deployment:
- create a new network with a public and private subnet to launch the gateways into
- launch the gateways into an existing network

The gateways are configured with the following topology:

![](./images/cp_cluster_topology.png)

Each gateway is created with two VNICs, one on the public subnet and one on the private subnet. 

Each subnet has a virtual secondary private IP created, both of which are assigned to the same gateway instance. The public virtual IP must be a permanent IP to be transfered between VNICs, the option to add an existing permanent IP later is provided. 

If the option for a new network is selected, a public and private subnet are created. A routing table for the private subnet will be created with the backend cluster IP as the default route for all traffic. A routing table for the frontend will have the default route pointed to an internet gateway created.

The First Time Wizard for both instances are handled by a cloud-init script.

The password for the gateway must be set by SSHing to the instance, and password authentication over SSH is disabled by default

Once the deployment has finished, follow the part 6 of this [guide](https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk142872&partition=General&product=CloudGuard) to finish configuring the cluster with a Check Point security management server.
