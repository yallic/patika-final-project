resource "aws_kms_key" "protein-kms-key" {
  description             = "protein-kms-key"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "protein-cloudwatch" {
  name = "protein-cloudwatch"
}

resource "aws_ecs_cluster" "protein-bitirme-projesi-cluster" {
  name = "protein-bitirme-projesi-cluster"



  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.protein-kms-key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.protein-cloudwatch.name
      }
    }
  }
}
resource "aws_ecs_task_definition" "protein-bitirme-projesi-task" {
  family = "protein-bitirme-projesi-task"
  requires_compatibilities = ["FARGATE"]
  #launch_type = "FARGATE"
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name      = "protein-react-container"
      image     = "yallic/protein-bitirme"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

    runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }


}


resource "aws_ecs_service" "protein-bitirme-projesi-service" {
  name            = "protein-bitirme-projesi-service"
  cluster         = aws_ecs_cluster.protein-bitirme-projesi-cluster.id
  task_definition = aws_ecs_task_definition.protein-bitirme-projesi-task.arn
  desired_count   = 1
  launch_type = "FARGATE"
  

  network_configuration{
   assign_public_ip = true
   subnets = module.vpc.public_subnets
   security_groups = ["${aws_security_group.protein-bitirme-projesi-sg.id}"]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.protein-lb-targetgroup.arn
    container_name   = "protein-react-container"
    container_port   = 80
  }


}