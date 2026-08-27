# ADR 0001: Usar RDS PostgreSQL

## Status

Proposto

## Contexto

A aplicacao atual ja utiliza PostgreSQL e possui um modelo relacional com forte necessidade de integridade, transacoes e consultas por relacionamento.

## Decisao

Usar PostgreSQL gerenciado em RDS para homologacao e producao.

## Consequencias

- Menor carga operacional sobre backup, patching e disponibilidade.
- Compatibilidade direta com migrations e queries atuais.
- Necessidade de configurar rede privada, security groups e acesso controlado por EKS/Lambda.

