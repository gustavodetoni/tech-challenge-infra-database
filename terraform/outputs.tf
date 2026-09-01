output "environment" {
  value = var.environment
}

output "database_host" {
  description = "Endpoint do RDS PostgreSQL."
  value       = aws_db_instance.postgres.address
}

output "database_name" {
  description = "Nome do banco criado no RDS."
  value       = aws_db_instance.postgres.db_name
}

output "database_port" {
  description = "Porta do PostgreSQL."
  value       = aws_db_instance.postgres.port
}

output "database_username" {
  description = "Usuario master do PostgreSQL."
  value       = aws_db_instance.postgres.username
  sensitive   = true
}

output "database_arn" {
  description = "ARN do RDS PostgreSQL."
  value       = aws_db_instance.postgres.arn
}

output "database_security_group_id" {
  description = "Security group do RDS PostgreSQL."
  value       = aws_security_group.postgres.id
}

output "database_subnet_group_name" {
  description = "Subnet group privado do RDS."
  value       = aws_db_subnet_group.postgres.name
}

output "database_parameter_group_name" {
  description = "Parameter group PostgreSQL usado pelo RDS."
  value       = aws_db_parameter_group.postgres.name
}

output "postgresql_log_group_name" {
  description = "Log group CloudWatch com logs PostgreSQL."
  value       = aws_cloudwatch_log_group.postgresql.name
}

output "database_url_template" {
  description = "Template de DATABASE_URL esperado pela API/Lambda. Substitua <password> por segredo seguro."
  value       = "postgres://${aws_db_instance.postgres.username}:<password>@${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/${aws_db_instance.postgres.db_name}?sslmode=require"
  sensitive   = true
}
