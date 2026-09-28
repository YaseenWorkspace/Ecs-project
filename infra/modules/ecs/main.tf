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
    security_groups  = [aws_security_group.ecs_tasks.id]   
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
          #"awslogs-group"         = aws_cloudwatch_log_group.app.name
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






