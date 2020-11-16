resource "aws_route53_zone" "primary" {
  name = "inharnsway.com"
}
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.inharnsway.com"
  type    = "A"
  ttl     = "300"
  alias {
    name                   = aws_lb.foundry_loadbalancer.dns_name
    zone_id                = aws_lb.foundry_loadbalancer.zone_id
    evaluate_target_health = true
  }
}