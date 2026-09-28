resource "aws_ecs_cluster" "main" {
  name = "ecs-project-cluster"
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





