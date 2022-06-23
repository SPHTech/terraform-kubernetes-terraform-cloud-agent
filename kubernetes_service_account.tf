resource "kubernetes_service_account" "tfc_agent_service_account" {
  count = var.cluster_access ? 1 : 0

  metadata {
    labels = {
      "app.kubernetes.io/name"           = "terraform-cloud-agent"
      "app.kubernetes.io/module-version" = local.module-version
      "app.kubernetes.io/managed-by"     = "terraform"
    }
    name      = "terraform-cloud-agent"
    namespace = var.create_namespace ? kubernetes_namespace.tfc_agent_namespace[0].metadata[0].name : var.namespace
    annotations = var.create_aws_eks_irsa_role ? {"eks.amazonaws.com/role-arn" = module.tfc_agent_irsa_role.iam_role_arn} : {"kubernetes.io/service-account.name" = "terraform-cloud-agent"}
  }
}
