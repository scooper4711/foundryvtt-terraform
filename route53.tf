resource "aws_route53_zone" "primary" {
  name = var.domain
}
resource "aws_route53_record" "www" {
  for_each = var.ec2_instances
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${each.key.server}.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.foundry[each.key].public_ip]
}