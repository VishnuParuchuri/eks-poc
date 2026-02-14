output "nginx_external_dns" {
  value = kubernetes_service.nginx_service.status[0].load_balancer[0].ingress[0].hostname
}