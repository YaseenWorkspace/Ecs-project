resource "aws_lb" "alb" {
    name               = "my-alb"
    internal           = false
    load_balancer_type = "application"
    subnets            = [var.subneta, var.subnetb]
    security_groups =     [aws_security_group.allow_tls.id]
}

resource "aws_security_group" "allow_tls" {

  # Its name in AWS. Must be unique within the VPC.
  name        = "allow_tls"

  # A note describing its purpose. Just text: it doesn't create any rules.
  # Changing it later makes Terraform delete and recreate the whole group.
  description = "Allow TLS inbound traffic and all outbound traffic"

  # Which VPC it belongs to. A security group only works inside its own VPC.
  vpc_id      = var.vpc_id

  # Label shown in the "Name" column in the AWS console.
  tags = {
    Name = "allow_tls"
  }
}  


# Create a single rule and add it to a security group.
resource "aws_security_group_rule" "inbound" {

  # "ingress" = inbound (traffic coming IN). The other option is "egress" (going OUT).
  type              = "ingress"

  # The port range allowed. 0 to 65535 is every possible port.
  from_port         = 80
  to_port           = 80
  

  # Only TCP traffic (web, SSH, databases). Not UDP or ICMP (ping).
  protocol          = "tcp"

  cidr_blocks       =  ["0.0.0.0/0"]


  # Which security group this rule is added to.
  security_group_id =  aws_security_group.allow_tls.id
}


resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.allow_tls.id
}



# The group of targets (your ECS tasks) the ALB sends traffic to.
resource "aws_lb_target_group" "app" {

  # Its name in AWS. Letters, numbers and hyphens only (no underscores).
  name        = "app-tg"

  # The port your container listens on (EXPOSE 3000 in the Dockerfile).
  port        = 3000
  protocol    = "HTTP"

  # Which VPC the targets live in.
  vpc_id      = var.vpc_id

  # "ip" is required for ECS Fargate: each task gets its own IP address.
  target_type = "ip"

  # The ALB checks this path on each task. Only healthy tasks get traffic.
  health_check {
    path    = "/"
    matcher = "200"
  }
}


# Listens on the ALB's port 80 and forwards every request to the target group.
resource "aws_lb_listener" "http" {

  # Which load balancer this listener is on.
  load_balancer_arn = aws_lb.alb.arn

  # The port and protocol users connect to.
  port              = 80
  protocol          = "HTTP"

  # What to do with the traffic: send it to the target group.
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
