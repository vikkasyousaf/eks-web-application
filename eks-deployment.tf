resource "kubernetes_deployment" "nginx-application" {
  metadata {
    name = "nginx-application-deployment"
    labels = {
      app = "nginx-application"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx-application"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-application"
        }
      }

      spec {
        container {
          image = "cloudcomputing17/nginx-application:0.4"
          name  = "nginx-application"
          port {
            container_port = 8080
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
