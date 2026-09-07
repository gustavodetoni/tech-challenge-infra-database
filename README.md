# Tech Challenge Infra Database

Infraestrutura do banco de dados gerenciado e documentacao da modelagem relacional da oficina.

## Repositorios Da Entrega

- Aplicacao principal: https://github.com/gustavodetoni/tech-challenge-project
- Lambda Auth CPF/CNPJ: https://github.com/gustavodetoni/tech-challenge-auth-lambda
- Infra Kubernetes: https://github.com/gustavodetoni/tech-challenge-infra-k8s
- Infra Database: https://github.com/gustavodetoni/tech-challenge-infra-database

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
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
terraform -chdir=terraform init
terraform -chdir=terraform validate
```

Este repositorio consome os outputs do state do `tech-challenge-infra-k8s` para reutilizar VPC, subnets privadas, security group dos nodes do EKS e security group da Lambda.

## Deploy

O workflow de deploy esta versionado em `.github/workflows/deploy.yml`, mas o deploy automatico esta temporariamente desabilitado para o primeiro push do repositorio.
Quando as variaveis AWS/Terraform/database estiverem configuradas, o workflow deve ser reativado para deploy nas branches de homologacao e producao.

Fluxo previsto:

```text
pull_request -> terraform fmt/validate
homolog      -> terraform apply homolog
main         -> terraform apply producao
```

## Ordem De Deploy

Este repositorio deve ser aplicado depois do `tech-challenge-infra-k8s`, porque depende dos outputs de VPC, subnets privadas e security groups.

Depois do deploy, os outputs devem alimentar:

- `DATABASE_URL` da aplicacao principal.
- `DATABASE_URL` da Lambda Auth.
- Security rules para acesso privado de EKS e Lambda.

## Variaveis Pendentes Para Subida

Secrets GitHub:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
TF_STATE_BUCKET
TF_VAR_DB_PASSWORD
```

Variaveis Terraform principais:

```text
environment
db_name
db_user
db_instance_class
k8s_state_bucket
k8s_state_key
```

## Arquitetura

```text
EKS / Lambda
  -> Security Group
      -> RDS PostgreSQL privado
          -> Backups
          -> Logs
```

## Documentacao Do Banco

- [Justificativa PostgreSQL](docs/database/postgresql-choice.md)
- [Diagrama ER](docs/database/er-diagram.md)
- [Relacionamentos](docs/database/relationships.md)
- [Indices e constraints](docs/database/indexes-and-constraints.md)
- [Modelagem](docs/database/modeling.md)

## Links

- Repositorio: https://github.com/gustavodetoni/tech-challenge-infra-database
- Swagger da API principal: https://github.com/gustavodetoni/tech-challenge-project/blob/main/docs/swagger.yaml
- Postman da API principal: https://github.com/gustavodetoni/tech-challenge-project/blob/main/docs/collections/tech-challenge.postman_collection.json
- Endpoint do banco: privado, nao aplicavel
- Deploy homologacao: nao possui URL publica; outputs serao gerados apos o primeiro deploy cloud.
- Deploy producao: nao possui URL publica; outputs serao gerados apos o primeiro deploy cloud.
