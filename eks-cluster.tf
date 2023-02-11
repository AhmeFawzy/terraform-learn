provider "kubernetes" {
    config_path    = "~/.kube/config"//"C:\\Users\\ahmed\\.kube\\cluster-kubeconfig.yaml" //WE ARE TELLING KUBERNETES NOT TO CREATE A DEFAULT CONFIG .KUBE CONFIG FILE WE WILL CREATE A NEW ONE 
   // host = data.aws_eks_cluster.myapp-eks-cluster.endpoint //CONFIGURE A PROVIDER WITH ENDPOINT OF K8S CLUSTER( API SERVER)
   // token = data.aws_eks_cluster_auth.myapp-eks-cluster.token
   // cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-eks-cluster.certificate_authority.0.data)
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.7.0"

  cluster_name = "myapp-eks-cluster"  
  cluster_version = "1.24"

  subnet_ids = module.flokiapp-vpc.private_subnets
  vpc_id = module.flokiapp-vpc.vpc_id

  tags = {
    environment = "development"
    application = "myapp"
  }

  eks_managed_node_groups ={
    prod = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t2.micro"]
    }
  }
}






