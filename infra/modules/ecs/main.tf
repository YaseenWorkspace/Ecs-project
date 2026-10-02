resource "aws_ecs_cluster" "main" {
  name = "ecs-project-cluster"
}


resource "aws_ecs_service" "mongo" {
  name            = "ecs-project-service"                  
  cluster         = aws_ecs_cluster.main.id                
  task_definition = aws_ecs_task_definition.service.arn    
  desired_count   = 1                                      
  launch_type     = "FARGATE"                             

  network_configuration {                                  
    subnets          = [var.private_subnet]            
    security_groups  = [aws_security_group.ecs_task.id]
    assign_public_ip = false                               
  }

  load_balancer {
    target_group_arn = var.target_group_arn                
    container_name   = "first"                             
    container_port   = 3000                                
  }

  deployment_circuit_breaker {                           
    enable   = true                                       
    rollback = true
  }  
}



resource "aws_ecs_task_definition" "service" {
  family                   = "service"
  requires_compatibilities = ["FARGATE"]               
  network_mode             = "awsvpc"                 
  cpu                      = "256"                    
  memory                   = "512"
  execution_role_arn       = aws_iam_role.task_execution.arn 

  container_definitions = jsonencode([
    {
      name         = "first"
      image        = "${var.image_url}:${var.image_tag}"   
      essential    = true
      portMappings = [{ containerPort = 3000 }]            

      logConfiguration = {                                
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app.name
          "awslogs-region"        = "eu-west-2"
          "awslogs-stream-prefix" = "app"
        }
      }
    }
    
  ])
}

resource "aws_iam_role" "task_execution" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"   
        }
      },
    ]
  })
}

# Give the role AWS's standard ECS permissions: pull images from ECR and write logs to CloudWatch.
resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# Where the container's logs are stored in CloudWatch.
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/ecs-project"
  retention_in_days = 7
}

resource "aws_iam_group" "group" {
  name = "test-group"
}

resource "aws_security_group" "ecs_task" {
  name        = "ecs-tasks-sg"
  description = "Allow traffic from the ALB to the ECS tasks"
  vpc_id      = var.vpc_id
}



resource "aws_security_group_rule" "inbound" {

  # "ingress" = inbound (traffic coming IN). The other option is "egress" (going OUT).
  type              = "ingress"

  # The port range allowed. 0 to 65535 is every possible port.
  from_port         = 3000
  to_port           = 3000
  

  # Only TCP traffic (web, SSH, databases). Not UDP or ICMP (ping).
  protocol          = "tcp"

  cidr_blocks       =  ["0.0.0.0/0"]


  # Which security group this rule is added to.
  security_group_id =  aws_security_group.ecs_task.id
}

  resource "aws_security_group_rule" "outbound" {

  # "ingress" = inbound (traffic coming IN). The other option is "egress" (going OUT).
  type              = "egress"

  # The port range allowed. 0 to 65535 is every possible port.
  from_port         = 0
  to_port           = 0
  

  # Only TCP traffic (web, SSH, databases). Not UDP or ICMP (ping).
  protocol          = -1

  cidr_blocks       =  ["0.0.0.0/0"]


  # Which security group this rule is added to.
  security_group_id =  aws_security_group.ecs_task.id
}
