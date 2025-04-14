provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = var.project_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    Name = var.project_name
  }
}

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.6.0"

  cluster_name = "${var.project_name}-cluster"
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_exec.arn

  container_definitions = jsonencode([{
    name      = "simpletimeservice"
    image     = var.container_image
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
    essential = true
  }])
}

resource "aws_iam_role" "ecs_task_exec" {
  name = "${var.project_name}-ecs-exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_policy" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app-sg"
  description = "Allow HTTP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "lb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.7.0"

  name            = "${var.project_name}-alb"
  load_balancer_type = "application"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets

  security_groups = [aws_security_group.app_sg.id]

  target_groups = [
    {
      name_prefix      = "simple"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "ip"
      health_check = {
        path                = "/"
        matcher             = "200"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
    }
  ]

  listeners = [
    {
      port     = 80
      protocol = "HTTP"
      default_action = {
        type             = "forward"
        target_group_index = 0
      }
    }
  ]
}

resource "aws_ecs_service" "app_service" {
  name            = "${var.project_name}-service"
  cluster         = module.ecs_cluster.cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1

  network_configuration {
    subnets         = module.vpc.private_subnets
    assign_public_ip = false
    security_groups = [aws_security_group.app_sg.id]
  }

  load_balancer {
    target_group_arn = module.lb.target_groups[0].arn
    container_name   = "simpletimeservice"
    container_port   = 8080
  }

  depends_on = [module.lb]
}
