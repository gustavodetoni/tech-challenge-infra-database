variable "project_name" {
  description = "Nome base usado nos recursos criados na AWS."
  type        = string
  default     = "tech-challenge"
}

variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente de deploy."
  type        = string
  default     = "homolog"
}

variable "db_name" {
  description = "Nome do banco PostgreSQL."
  type        = string
  default     = "tech_challenge"
}

variable "db_user" {
  description = "Usuario master do PostgreSQL."
  type        = string
  default     = "tech_challenge"
}

variable "db_password" {
  description = "Senha master do PostgreSQL."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Classe da instancia RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Armazenamento inicial em GB."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Limite de autoscaling de armazenamento em GB."
  type        = number
  default     = 50
}

variable "backup_retention_period" {
  description = "Retencao de backups em dias."
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Janela preferencial de backup em UTC."
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Janela preferencial de manutencao em UTC."
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "cloudwatch_log_retention_days" {
  description = "Retencao dos logs PostgreSQL no CloudWatch."
  type        = number
  default     = 14
}

variable "k8s_state_bucket" {
  description = "Bucket S3 do state do repositorio tech-challenge-infra-k8s."
  type        = string
}

variable "k8s_state_key" {
  description = "Key do state do repositorio tech-challenge-infra-k8s."
  type        = string
  default     = "tech-challenge/k8s/terraform.tfstate"
}

variable "k8s_state_region" {
  description = "Regiao do bucket S3 do state do repositorio tech-challenge-infra-k8s."
  type        = string
  default     = "us-east-1"
}

variable "lambda_security_group_ids" {
  description = "Security groups das Lambdas que podem acessar o RDS."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags aplicadas aos recursos."
  type        = map(string)

  default = {
    Project = "tech-challenge"
    Managed = "terraform"
  }
}
