resource "aws_route53_zone" "primary" {
  name = var.domain
}
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.inharnsway.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.foundry.public_ip]
}