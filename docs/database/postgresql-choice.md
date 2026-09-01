# Justificativa Do PostgreSQL

O banco escolhido para a solucao e PostgreSQL gerenciado em AWS RDS.

## Motivos

- O projeto principal ja usa PostgreSQL, reduzindo risco de migracao.
- O dominio da oficina e naturalmente relacional: clientes possuem veiculos, veiculos geram ordens de servico, ordens possuem orcamentos versionados, itens e historico.
- O fluxo de aprovacao de orcamento e baixa de estoque exige transacoes ACID.
- O modelo atual usa constraints, chaves estrangeiras e indices parciais, recursos bem suportados pelo PostgreSQL.
- RDS reduz carga operacional com backup, patching, criptografia em repouso e logs gerenciados.

## Consistencia

O PostgreSQL protege integridade com:

- Primary keys UUID.
- Foreign keys entre entidades principais.
- Unique indexes para documento, placa, chassi, codigo da OS e versao do orcamento.
- Check constraints para valores monetarios, quantidades, anos e quilometragem.
- Transacoes para criar/revisar/enviar/aprovar orcamentos.

## Performance

O modelo foi otimizado para as consultas mais importantes:

- Busca de cliente por documento.
- Busca de veiculo por placa.
- Busca de OS por codigo.
- Listagem de OS por cliente, veiculo e status.
- Historico de status ordenado por data.
- Itens de orcamento por versao.

## Operacao

O Terraform configura:

- RDS privado em subnets privadas.
- Security group permitindo acesso apenas de EKS e Lambda Auth.
- Criptografia de storage.
- Backup diario.
- Logs PostgreSQL no CloudWatch.
- Parameter group com logs de conexao e queries lentas.

