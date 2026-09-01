# Relacionamentos

## Cliente E Veiculo

Um cliente pode possuir muitos veiculos.

```text
clients 1:N vehicles
```

Cada veiculo pertence a exatamente um cliente.

## Ordem De Servico

Uma ordem de servico pertence a um cliente e a um veiculo.

```text
clients 1:N service_orders
vehicles 1:N service_orders
users 1:N service_orders
```

O usuario atribuido e opcional, permitindo abrir a OS antes da distribuicao operacional.

## Orcamento

Uma OS pode ter varias versoes de orcamento.

```text
service_orders 1:N budgets
budgets 1:N budget_services
budgets 1:N budget_parts
```

O indice unico `service_order_id, version` garante que duas versoes iguais nao existam para a mesma OS.

## Execucao

Quando o cliente aprova um orcamento, os itens cotados sao materializados em:

```text
service_order_services
service_order_parts
```

Isso preserva o historico do orcamento e separa cotacao de execucao.

## Estoque

Pecas possuem saldo atual em `parts.stock_quantity` e auditoria em `stock_movements`.

```text
parts 1:N stock_movements
service_orders 1:N stock_movements
```

A aprovacao do orcamento faz baixa de estoque em transacao e registra movimento `OUT`.
