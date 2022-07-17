resource "aws_ecs_cluster" "protein-bitirme-projesi-cluster" {
  name = "protein-bitirme-projesi-cluster"

  # setting {
  #   name  = "containerInsights"
  #   value = "enabled"
  # }
}
# resource "aws_ecs_cluster_capacity_providers" "fargate" {
#   cluster_name = aws_ecs_cluster.protein-react.name

#   capacity_providers = ["FARGATE"]

#   default_capacity_provider_strategy {
#     base              = 1
#     weight            = 100
#     capacity_provider = "FARGATE"
#   }
# }
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