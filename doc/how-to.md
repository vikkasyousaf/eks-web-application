### Description
I have choose to create aws eks as it easy to operate and manage the cluster and worker nodes. AWS manages the servers for us. and we just have to specify some configurations of server instance types. For the given project i have create eks cluster using terraform version `1.1`.

### EKS Cluster Setup
For the give project i have create the following Resources:
* VPC with two private subnets as it is more secure to run the application in private nodes.
* Internet gateways so that the application are able to run on http and https.
* Create respective routing table and its association.
* Created eks cluster using the module `terraform-aws-modules/eks/aws` with cluster version `1.21`.
* Created kms Encryption key to encrypt the secrets in the cluster(for now we dont have any secrets).
* For this demo i have used a smaller instances as we will have to run only a single deployment.
* I have create a `eks-deployment.tf` which will be deployment to the cluster when the cluster is up and running.
* I have also create `service.tf` which is using LoadBalancer. This will allow us to access the application externally.

## How to rollout
For this project we are using terraform version `1.1`.
Before running the project make sure to add `account_id` of you aws account in `variable.tf` and the iam user in `map_users`.
### Testing Instructions
```
terraform init
terraform plan
```

### How to roll out
```
terraform apply
```

Once the cluster is rolled out, we have to also update the kube_config file so that we have the correct configuration/certifiacte in order to access the clusters
```
aws eks update-kubeconfig --name terraform-eks-demo --region eu-central-1
```
If you have multiple context, then you can use the following command to switch to the correct contex
```
kubectl config use-context arn:aws:eks:eu-central-1:<account_id>:cluster/terraform-eks-demo
```
```
kubectl get nodes
NAME                                         STATUS   ROLES    AGE     VERSION
ip-10-0-1-70.eu-central-1.compute.internal   Ready    <none>   26m   v1.21.5-eks-9017834
```
```
kubectl get ns
NAME              STATUS   AGE
default           Active   31m
kube-node-lease   Active   31m
kube-public       Active   31m
kube-system       Active   31m
```
```
kubectl get pods -n default
NAME                                            READY   STATUS    RESTARTS   AGE
nginx-application-deployment-7d95dd8998-hfj6w   1/1     Running   0          2m14s
nginx-application-deployment-7d95dd8998-k9blk   1/1     Running   0          2m14s
```
```
kubectl logs -f nginx-application-fbc884985-pt2lp  -n default
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: /etc/nginx/conf.d/default.conf is not a file or does not exist
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2022/04/20 11:09:57 [notice] 1#1: using the "epoll" event method
2022/04/20 11:09:57 [notice] 1#1: nginx/1.21.6
2022/04/20 11:09:57 [notice] 1#1: built by gcc 10.3.1 20211027 (Alpine 10.3.1_git20211027)
2022/04/20 11:09:57 [notice] 1#1: OS: Linux 5.4.181-99.354.amzn2.x86_64
2022/04/20 11:09:57 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2022/04/20 11:09:57 [notice] 1#1: start worker processes
2022/04/20 11:09:57 [notice] 1#1: start worker process 22
```
```
kubectl get svc
NAME                TYPE           CLUSTER-IP       EXTERNAL-IP                                                                  PORT(S)        AGE
kubernetes          ClusterIP      172.20.0.1       <none>                                                                       443/TCP        60m
nginx-application   LoadBalancer   172.20.214.116   a8c37c98dfffd4b17a67a5248b9df6e0-1665262233.eu-central-1.elb.amazonaws.com   80:31883/TCP   26m
```
### Demo
![](https://github.com/vikkasyousaf/eks-web-application/blob/main/doc/demo.png)

### TODO
This is a very basic eks cluster. In order to make it production ready cluster, we will need to make the following adjustments:
* Create and add ssh key to the nodes to access the node for maintanace and troubleshooting
* Creating an IAM OIDC identity provider for the cluster, to create IAM roles to associate with a service account in the cluster, instead of using kiam or kube2iam
* Creating role and cluster role binding for the CI/CD
* Creating role and cluster role for user managment, creating separate role for engineer and Devops/SRE
* Provision cluster using ansible or similar tools is also an option.
* Add know gpg key to the respository so that only known user could rollout changes to the cluster
* Creating a CI/CD pipeline to rollout deployment to the cluster.
* Create a make file which include lint check, code formatting and so on
* Should have dedicated IAM User or role to run terraform apply
* Integrate atlantis to the respository so that the terraform plan and apply are automated.
* Configure dynamodb for the version control of terraform state
* Create a pipeline to push the terraform state file to s3 bucket

### Monitoring
* The module allow us to enable logging so that the logs are available on cloudwatch.
* Beside this there a lot of logs shipper which could be use to ship logs e.g using logstash/filebeat to ship logs to elasticsearch cluster.
* For metric it also depend on to tool which tool we will use to monitoring the cluster. e.g cloudwatch, promethous, elasticsearch etc.

Notes:
* This project will also deploy the web application using terraform, beside this i have also add the [yaml](https://github.com/vikkasyousaf/eks-web-application/blob/main/web-application/nginx-application) file if you want to deploy the web-application manually.
* Once thre cluster is up and running, you can use the following command to deploy the application:
```
kubectl apply -f nginx-application
```
