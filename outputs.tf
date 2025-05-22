output "wordpress_tg_arn" {
  description = "ARN of the WordPress Target Group"
  value       = aws_lb_target_group.wordpress.arn
}