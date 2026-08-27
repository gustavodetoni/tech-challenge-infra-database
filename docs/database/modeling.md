# Modelagem Do Banco

O banco principal recomendado e PostgreSQL gerenciado, por aderencia ao projeto atual, suporte transacional, integridade referencial, indices parciais e boa operacao em ambiente cloud.

## Entidades Principais

- `users`: usuarios administrativos e operacionais.
- `clients`: clientes identificados por CPF/CNPJ.
- `vehicles`: veiculos vinculados a clientes.
- `services`: catalogo de servicos.
- `parts`: pecas e insumos com estoque.
- `service_orders`: ordens de servico.
- `budgets`: versoes de orcamento por ordem de servico.
- `budget_services` e `budget_parts`: itens cotados em cada orcamento.
- `service_order_services` e `service_order_parts`: itens materializados apos aprovacao.
- `stock_movements`: auditoria de movimentacao de estoque.

## Ajustes De Performance

- Indices por documento de cliente, placa de veiculo e codigo da OS.
- Indices por status e relacionamentos de OS.
- Indices parciais com `deleted_at IS NULL` para soft delete.
- Transacoes para aprovacao de orcamento e baixa de estoque.

