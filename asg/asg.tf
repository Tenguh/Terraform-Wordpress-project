# Create a launch template for WordPress instances
resource "aws_launch_template" "wordpress_lt" {
  name_prefix   = "wordpress-lt"
  image_id      = var.ami_id
  instance_type = "t3.medium"
  key_name      = var.key_pair_name
  
 user_data = base64encode(templatefile("scripts/userdata.sh", { 
  endpoint      = var.db_endpoint,
  mount_script  = file("scripts/mounttarget.sh")
}))

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.ec2_sg_id]

  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "wordpress_asg" {
  name                 = "wordpress-asg"
  min_size             = 2
  max_size             = 6
  desired_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns    = var.target_group_arns

  launch_template {
    id      = aws_launch_template.wordpress_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "wordpress-asg-instance"
    propagate_at_launch = true
  }
}

# Scale-up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "wordpress_scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}

# CloudWatch alarm to trigger scale-up
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "wordpress-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_description = "Scale up if CPU > 70% for 2 periods"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

# Scale-down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "wordpress_scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}

# CloudWatch alarm to trigger scale-down
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "wordpress-low-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_description = "Scale down if CPU < 30% for 2 periods"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}
