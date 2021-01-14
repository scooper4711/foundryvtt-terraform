resource "aws_route53_zone" "primary" {
  name = var.domain
}
resource "aws_route53_record" "www" {
  for_each = { for ec2 in var.ec2_instances : ec2.name => ec2 }
  zone_id  = aws_route53_zone.primary.zone_id
  name     = "${each.value.name}.${var.domain}"
  type     = "A"
  ttl      = "300"
  records  = [aws_eip.foundry[each.key].public_ip]
}