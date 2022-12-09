provider "kubernetes" {
    load_config_file = "false" //WE ARE TELLING KUBERNETES NOT TO CREATE A DEFAULT CONFIG .KUBE CONFIG FILE WE WILL CREATE A NEW ONE 
    host = data.aws_eks_cluster.flokyapp-cluster.endpoint //CONFIGURE A PROVIDER WITH ENDPOINT OF K8S CLUSTER( API SERVER)
    token = data.aws_eks_cluster_auth.flokiapp-cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.flokiapp-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "flokiapp-cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "flokiappp-cluster" {
    name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.4"

  cluster_name    = "floki-cluster"
  cluster_version = "1.24"

  subnets = module.flokiapp-vpc.private_subnets // this is where our workload will be scheduled
  vpc_id = module.flokiapp-vpc.vpc_id

  tags = {
    environment = "development"
    application = "flokiapp"
  }

  worker_groups = [
    {
        instance_type = "t2.small"
        name = "worker-group-1"
        asg_desired_capacity = 2
    },
    {
        instance_type = "t2.medium"
        name = "worker-group-2"
        asg_desired_capacity = 1
    }
  ]
}