# Tech Challenge Infra Database

Infraestrutura do banco de dados gerenciado e documentacao da modelagem relacional da oficina.

## Repositorios Da Entrega

- Aplicacao principal: https://github.com/gustavodetoni/tech-challenge-project
- Lambda Auth CPF/CNPJ: https://github.com/gustavodetoni/tech-challenge-auth-lambda
- Infra Kubernetes: https://github.com/gustavodetoni/tech-challenge-infra-k8s
- Infra Database: https://github.com/gustavodetoni/tech-challenge-infra-database

## Proposito

Este repositorio provisiona o banco gerenciado PostgreSQL e documenta a modelagem relacional, indices, constraints, relacionamentos e decisoes de performance. Na Fase 4, a configuração espera bancos lógicos independentes no RDS (`tech_challenge`, `os_service` e `billing_service`), com cada URL entregue a apenas um microsserviço. O Execution Service usa MongoDB próprio provisionado no Kubernetes.

## Tecnologias

- Terraform
- AWS RDS PostgreSQL
- PostgreSQL
- GitHub Actions
- Mermaid para diagramas

## Governanca Dos Repositorios

Os repositórios oficiais da Fase 3 possuem branch protection na branch `main`. Para a Fase 4, os três novos repositórios já possuem workflows e branch `main` local; a proteção de branch e os PRs obrigatórios ainda precisam ser habilitados após a publicação dos remotes.

Branches de homologacao e producao sao atendidas por GitHub Actions. O deploy e automatizado pela esteira: apos o disparo definido no workflow, a pipeline valida Terraform, provisiona o RDS PostgreSQL na AWS e publica os outputs necessarios para a aplicacao e para a Lambda.

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

O deploy e automatizado pelo GitHub Actions para AWS usando Terraform.
A esteira provisiona o banco gerenciado PostgreSQL no RDS, cria a infraestrutura de seguranca associada e reutiliza os outputs de rede do repositorio `tech-challenge-infra-k8s`.

Antes do `terraform init`, o workflow faz bootstrap do backend S3. Esse passo cria o bucket de state quando necessario e cria um state vazio valido quando o objeto `tech-challenge/database/<ambiente>.tfstate` tiver sido removido, evitando a falha `HeadObject 403` comum em contas AWS Academy sem permissao de listagem completa.

Fluxo previsto:

```text
pull_request      -> terraform fmt/validate
main/homolog/prod -> terraform apply
destroy           -> terraform destroy controlado
```

Inputs do workflow:

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
- `OS_DATABASE_URL` e `BILLING_DATABASE_URL` dos Secrets do overlay Kubernetes.

## Terraform

A pasta `terraform/` e a fonte oficial de infraestrutura do banco gerenciado.
Ela provisiona:

- RDS PostgreSQL privado.
- Subnet group com subnets privadas do VPC do EKS.
- Security group permitindo acesso somente da API no EKS e da Lambda Auth.
- Parametros de banco para homologacao/producao.
- Outputs usados pelas demais esteiras.
- Bancos lógicos `os_service` e `billing_service` isolados por ownership e migrations próprias.
- Backend remoto S3 para state Terraform.

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

## Observabilidade

O banco fica em rede privada e e consumido pela API principal no EKS e pela Lambda Auth.
A rastreabilidade ponta a ponta e feita pelo `traceId`/`correlation_id` emitido pela aplicacao, que permite correlacionar chamadas HTTP, operacoes da API e erros de integracao com o RDS nos logs estruturados coletados pelo Datadog Agent.

O Datadog Agent instalado pelo repositorio `tech-challenge-infra-k8s` coleta metricas e logs do cluster Kubernetes, permitindo acompanhar latencia, erros, consumo de recursos, healthchecks e impactos operacionais ligados ao banco durante os fluxos de ordem de servico.

## Limitação atual da Fase 4

Os bancos lógicos `os_service` e `billing_service` são criados pelo Job idempotente `tech-challenge-database-bootstrap`, executado pelo workflow do repositório `tech-challenge-infra-k8s` antes do rollout dos microsserviços. O Terraform continua responsável pelo RDS, rede e segurança; o bootstrap roda dentro do cluster porque o RDS é privado.

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
- Deploy homologacao: RDS privado provisionado por Terraform, consumido pela API em https://hwq42fgalh.execute-api.us-east-1.amazonaws.com
- Deploy producao: mesmo fluxo automatizado de deploy, usando `environment=prod`.
