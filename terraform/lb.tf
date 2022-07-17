
resource "aws_lb" "protein-lb" {
  name               = "protein-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.protein-bitirme-projesi-sg.id}"]
  subnets            = module.vpc.public_subnets  

  enable_deletion_protection = false


}

resource "aws_lb_listener" "protein-lb-listener" {
  load_balancer_arn = aws_lb.protein-lb.arn
  port              = "80"
  protocol          = "HTTP"

    default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.protein-lb-targetgroup.arn
  }

}


resource "aws_lb_target_group" "protein-lb-targetgroup" {
  name     = "protein-lb-targetgroup"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = module.vpc.vpc_id
}