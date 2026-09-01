# Indices E Constraints

## Indices Unicos

| Tabela | Indice | Objetivo |
| --- | --- | --- |
| `users` | `lower(email)` | Evitar e-mails duplicados entre usuarios ativos. |
| `clients` | `document_number` | Garantir um cliente ativo por CPF/CNPJ. |
| `vehicles` | `plate` | Garantir uma placa ativa unica. |
| `vehicles` | `chassis` | Garantir chassi unico quando informado. |
| `services` | `name` | Evitar servicos ativos duplicados. |
| `parts` | `sku` | Garantir identificacao unica de peca/insumo. |
| `service_orders` | `code` | Permitir consulta segura da OS por codigo. |
| `budgets` | `service_order_id, version` | Garantir versionamento consistente de orcamentos. |

Os indices usam `deleted_at IS NULL` para preservar historico com soft delete sem bloquear recriacao futura.

## Indices De Consulta

| Tabela | Campos | Uso |
| --- | --- | --- |
| `clients` | `name` | Listagem administrativa. |
| `vehicles` | `client_id` | Listar veiculos por cliente. |
| `service_orders` | `client_id`, `vehicle_id`, `status`, `assigned_user_id` | Listagem e filtros operacionais. |
| `service_order_status_history` | `service_order_id`, `changed_at` | Linha do tempo da OS. |
| `budgets` | `service_order_id`, `status` | Busca do ultimo orcamento e filtros. |
| `budget_services` | `budget_id`, `service_id` | Detalhamento do orcamento. |
| `budget_parts` | `budget_id`, `part_id` | Detalhamento do orcamento. |
| `stock_movements` | `part_id`, `created_at`, `reference_type/reference_id` | Auditoria de estoque. |

## Constraints

- Valores monetarios nao podem ser negativos.
- Quantidade de itens precisa ser maior que zero.
- Estoque nao pode ficar negativo.
- Quilometragem nao pode ser negativa.
- Ano de fabricacao/modelo precisa estar entre 1900 e 2100.
- Status principais sao representados por enums PostgreSQL.

