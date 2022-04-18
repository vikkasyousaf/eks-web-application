resource "kubernetes_deployment" "nginx-application" {
  metadata {
    name = "nginx-application-deployment"
    labels = {
      app = "nginx-application"
    }
  }

  spec {
    replicas = 1

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
          image = "engineerflaconi/nginx-application:0.2"
          name  = "nginx-application"
          port {
            container_port = 8081
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
