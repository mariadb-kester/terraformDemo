## Using the infrastructure

Now that the infrastucture is created you will be able to check this on
the [DigitalOcean Website](https://www.digitalocean.com).

On the dashboard, find Kubernetes on the left hand side menu. You will find the Kubernetes Cluster that you have just
built:

![Kubernetes Cluster](../../images/digitalocean/DO_kube_cluster.png)

and, if you find the Container Registry menu option, you will find the second item that we built. This is a private
Container Registry that we will use to hold your containers that will be deployed to this infrastructure.

![Container Registry](../../images/digitalocean/DO_container_registry.png)

Unfortunately, we are unable to automate the integration via Terraform, and we therefore must tick the 'Integrate all
clusters' option and the `Save and Continue` button.

**It is very important that you do this, for the rest of the process to work**