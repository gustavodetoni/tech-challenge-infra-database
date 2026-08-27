# Tech Challenge Infra Database

Infraestrutura do banco de dados gerenciado e documentacao da modelagem relacional da oficina.

## Proposito

Este repositorio provisiona o banco gerenciado PostgreSQL e documenta a modelagem relacional, indices, constraints, relacionamentos e decisoes de performance.

## Tecnologias

- Terraform
- AWS RDS PostgreSQL
- PostgreSQL
- GitHub Actions
- Mermaid para diagramas

## Estrutura

```text
terraform/              Infraestrutura do RDS
docs/database/          Modelo relacional, ER e performance
docs/architecture/      ADRs/RFCs e diagramas especificos
```

## Execucao Local

```bash
terraform -chdir=terraform init
terraform -chdir=terraform validate
```

## Deploy

Fluxo previsto:

```text
pull_request -> terraform fmt/validate
homolog      -> terraform apply homolog
main         -> terraform apply producao
```

## Arquitetura

```text
EKS / Lambda
  -> Security Group
      -> RDS PostgreSQL privado
          -> Backups
          -> Logs
```

## Links

- Swagger/Postman da API principal: pendente
- Endpoint do banco: privado, nao aplicavel

