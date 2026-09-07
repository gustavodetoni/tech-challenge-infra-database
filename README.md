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

O deploy e executado manualmente pelo GitHub Actions para facilitar a demonstracao no AWS Academy e permitir destruir os recursos depois da gravacao.
O gatilho automatico por `push` esta comentado no workflow e deve ser habilitado apenas quando as branches de homologacao/producao estiverem configuradas.

Fluxo previsto:

```text
pull_request -> terraform fmt/validate
Run workflow -> action=apply, environment=homolog
Run workflow -> action=destroy, environment=homolog
```

Inputs do workflow manual:

```text
action       apply ou destroy
environment  homolog ou prod
```

## Ordem De Deploy

Este repositorio deve ser aplicado depois do `tech-challenge-infra-k8s`, porque depende dos outputs de VPC, subnets privadas e security groups.

Depois do deploy, os outputs devem alimentar:

- `DATABASE_URL` da aplicacao principal.
- `DATABASE_URL` da Lambda Auth.
- Security rules para acesso privado de EKS e Lambda.

## Secrets Para Subida

Secrets GitHub:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
TF_STATE_BUCKET
TF_VAR_DB_PASSWORD
```

As demais variaveis Terraform possuem defaults no repositorio para reduzir configuracao manual:

```text
db_name             tech_challenge
db_user             tech_challenge
db_instance_class   db.t3.micro
k8s_state_bucket    secrets.TF_STATE_BUCKET
k8s_state_key       tech-challenge/k8s/<ambiente>.tfstate
```

O workflow cria o bucket de state automaticamente caso ele ainda nao exista.

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
