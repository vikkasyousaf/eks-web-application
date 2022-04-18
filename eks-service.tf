resource "kubernetes_service" "nginxdemos" {
  metadata {
    name = "nginx-application-svc"
  }
  spec {
    selector = {
      app = "nginx-application"
    }
    port {
      port        = 80
      target_port = 8081
      protocol    = TCP
    }
    type = "LoadBalancer"
  }
}
