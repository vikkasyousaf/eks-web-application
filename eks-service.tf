resource "kubernetes_service" "nginxdemos" {
  metadata {
    name = "nginx-application"
  }
  spec {
    selector = {
      app = "nginx-application"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}
