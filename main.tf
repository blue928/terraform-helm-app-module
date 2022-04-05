# Uses a production-grade, enterprise-ready chart from Bitnami
# https://artifacthub.io/packages/helm/bitnami/drupal
# https://docs.bitnami.com/kubernetes/apps/drupal/get-started/expose-service/
# for ingress: https://docs.bitnami.com/kubernetes/apps/drupal/configuration/configure-ingress/


resource "helm_release" "drupal_dev" {
  name       = var.helm_app_name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "drupal"
  #version    = ""
  #namespace = "production-ns"
  namespace        = var.cluster_namespace
  create_namespace = var.create_namespace
  atomic           = var.atomic
  #cleanup_on_fail = true


  # MUST be false to connect to external database
  set {
    name  = "mariadb.enabled"
    value = var.mariadb_enabled
  }

  set {
    name  = "externalDatabase.port"
    value = "3306"
  }

  set {
    name  = "externalDatabase.host"
    value = var.externalDatabase_host
  }

  set {
    name  = "externalDatabase.user"
    value = var.externalDatabase_user
  }

  set {
    name  = "externalDatabase.password"
    value = var.externalDatabase_password
  }

  set {
    name  = "externalDatabase.database"
    value = var.externalDatabase_database
    #value = var.externaldbprod_database
  }

  set {
    name  = "replicaCount"
    value = "2"
  }

  set {
    name  = "global.storageClass"
    value = "aks-file-share-custom-sc-csi"
  }

  set {
    name  = "drupalUsername"
    value = "drupaltest"
  }

  set {
    name  = "drupalPassword"
    value = "testdrupal"
  }

  set {
    name  = "persistence.accesModes[0]"
    value = "ReadWriteMany"
  }

  set {
    name  = "persistence.size"
    value = "10Gi"
  }

  #set {
  #  name  = "service.type"
  #  value = "clusterIP"
  #}

  # Let's Encrypt or another certification method must already
  # be configured on the cluster for this to work.
  set {
    name  = "ingress.tls"
    value = "true"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "ingress.hostname"
    value = var.ingress_hostname
  }

}
