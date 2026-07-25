module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.2"

  cluster_name    = local.cluster_name
  cluster_version = "1.33"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true
  cluster_enabled_log_types      = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  cluster_addons = {
    amazon-cloudwatch-observability = {
      most_recent = true
    }
    vpc-cni = {
      before_compute = true
      most_recent    = true
    }
    kube-proxy = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
  }


  eks_managed_node_group_defaults = {

    ami_type = "AL2023_x86_64_STANDARD"
    iam_role_additional_policies = {
      CloudWatchAgentServerPolicy  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }

  }


  # Allow GitHub Actions IAM identity to access Kubernetes
  access_entries = {

    github_actions = {

      principal_arn = var.github_principal_arn

      policy_associations = {

        admin = {

          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

          access_scope = {
            type = "cluster"
          }

        }

      }

    }

  }


  eks_managed_node_groups = {

    one = {

      name = "node-group-1"

      instance_types = [
        "t3.medium"
      ]

      min_size     = 1
      max_size     = 3
      desired_size = 2

    }


    two = {

      name = "node-group-2"

      instance_types = [
        "t3.medium"
      ]

      min_size     = 1
      max_size     = 2
      desired_size = 1

    }

  }

}