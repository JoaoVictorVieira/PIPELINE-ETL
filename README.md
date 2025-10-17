# Pipeline ETL/ELT - Censo Demográfico 2022

## Visão Geral

Este projeto implementa um pipeline ETL/ELT completo para processamento e análise de dados do Censo Demográfico 2022 do IBGE, utilizando arquitetura de datalake em camadas (medalhão) com orquestração via Apache Airflow.

## Objetivos do Desafio

O projeto atende aos seguintes requisitos:

- Seleção e cálculo de 5 indicadores socioeconômicos
- Criação de estrutura PostgreSQL simulando datalake com arquitetura medalhão (Bronze/Silver/Gold)
- Definição de modelagem Gold utilizando Star Schema
- Desenvolvimento de notebooks para tarefas ETL/ELT com PySpark
- Utilização de orquestrador (Apache Airflow)
- Documentação completa do projeto

## Indicadores Selecionados

Os seguintes indicadores foram selecionados e calculados a partir dos dados do Censo 2022:

1. **Percentual de trabalhadores que recebem até um salário mínimo**
2. **Percentual de trabalhadores com rendimentos superiores a cinco salários mínimos**
3. **Rendimento nominal médio mensal de todos os trabalhos**
4. **Índice de Gini (Brasil e regiões)**
5. **Nível de ocupação da população com 14 anos ou mais**

Para análise detalhada dos indicadores, consulte o arquivo `ANALISE_INDICADORES.md`.

Para visualização detalhada da arquitetura, consulte o arquivo `ARQUITETURA.md`.

## Arquitetura Implementada

### Medallion Architecture (Arquitetura Medalhão)

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   BRONZE LAYER  │───▶│  SILVER LAYER   │───▶│   GOLD LAYER    │
│                 │    │                 │    │                 │
│ • Dados Brutos  │    │ • Dados Limpos  │    │ • Dados Analíticos
│ • Validação     │    │ • Normalização  │    │ • Indicadores   │
│ • Ingestão      │    │ • Dimensões     │    │ • Star Schema   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Bronze Layer
- Dados brutos do Censo 2022 (17 arquivos CSV)
- Validação de integridade e formato
- Ingestão direta sem transformações
- 8 tabelas criadas (1.381 registros)

### Silver Layer
- Dados limpos e normalizados
- Dimensões criadas (UF, Sexo, Cor/Raça, Instrução)
- Fatos com chaves estrangeiras
- 9 tabelas (4 dimensões + 5 fatos, 1.410 registros)

### Gold Layer (Star Schema)
- Dimensões: Tempo, Localidade
- Fato: Indicadores de Renda calculados
- Métricas prontas para análise
- 7 tabelas (3 dimensões + 4 fatos, 55 registros)

## Stack Tecnológica

- **Python 3.10+** - Linguagem principal
- **Apache Spark 3.5.1** - Processamento distribuído
- **PostgreSQL 15** - Banco de dados relacional
- **Apache Airflow 2.8.1** - Orquestração de workflows
- **Docker & Docker Compose** - Containerização
- **JupyterLab** - Desenvolvimento e análise

## Estrutura do Projeto

```
PIPELINE-ETL/
├── data/                          # Dados do Censo 2022 (17 arquivos CSV)
├── notebooks/                     # Notebooks Jupyter
│   ├── bronze.ipynb               # Bronze Layer - Ingestão
│   ├── silver.ipynb               # Silver Layer - Limpeza e dimensões
│   └── gold.ipynb                 # Gold Layer - Indicadores calculados
├── airflow/                       # Configuração Airflow
│   ├── dags/                      # DAGs do Airflow
│   │   ├── censo_etl_pipeline.py  # Pipeline principal
│   │   └── censo_monitoring.py    # Monitoramento
│   └── logs/                      # Logs do Airflow
├── sql/                           # Scripts SQL
│   └── init_schemas.sql           # Schemas do banco
├── src/utils/                     # Utilitários
│   ├── db.py                      # Conexão PostgreSQL
│   └── io.py                      # I/O e Spark Session
├── docker-compose.yml             # Orquestração de containers
├── Dockerfile                     # Imagem customizada
├── requirements.txt               # Dependências Python
├── etl_censo_dump.sql            # Dump completo do banco
├── ANALISE_INDICADORES.md         # Análise detalhada dos indicadores
├── CHANGELOG.md                   # Histórico de mudanças
└── README.md                      # Este arquivo
```

## Como Executar

### Pré-requisitos
- Docker e Docker Compose instalados
- 8GB RAM disponível
- Portas 5432, 8080, 8888 livres

### Iniciar Containers

```bash
docker-compose up -d
```

Aguarde 1-2 minutos para inicialização completa.

### Acessar JupyterLab

Abra o navegador em: http://localhost:8888

### Executar Notebooks

Execute os notebooks na seguinte ordem:

1. **bronze.ipynb** - Ingestão de dados brutos (2-3 minutos)
2. **silver.ipynb** - Limpeza e normalização (1-2 minutos)
3. **gold.ipynb** - Cálculo de indicadores (1-2 minutos)

### Acessar Resultados

**PostgreSQL**:
```bash
docker exec -it etl_postgres psql -U etl_user -d etl_censo
```

**Consultas úteis**:
```sql
-- Listar schemas
\dn

-- Listar tabelas
\dt bronze.*
\dt silver.*
\dt gold.*

-- Consultar indicadores
SELECT * FROM gold.fato_indicadores_renda;
```

**Airflow** (opcional):
- URL: http://localhost:8080
- Usuário: admin
- Senha: admin

## Resultados Obtidos

### Indicadores Principais

| Indicador | Valor |
|-----------|-------|
| Trabalhadores até 1 SM | 37.00% |
| Trabalhadores > 5 SM | 20.00% |
| Rendimento médio Brasil | R$ 5.132,71 |
| Índice de Gini | 0.6875 |
| Nível de ocupação 14+ | 72.26% |

Consulte `ANALISE_INDICADORES.md` para análise detalhada com insights e validações.

### Qualidade dos Dados
- Cobertura: 100% dos arquivos CSV processados
- Validação: Todos os indicadores calculados com sucesso
- Performance: Pipeline executa em menos de 5 minutos
- Confiabilidade: Orquestração automatizada via Airflow

## Dump do Banco de Dados

O arquivo `etl_censo_dump.sql` contém o dump completo do banco PostgreSQL com todas as camadas (Bronze, Silver e Gold).

### Restaurar Dump

```bash
# Restaurar no container
docker exec -i etl_postgres psql -U etl_user < etl_censo_dump.sql

# Ou copiar para o container primeiro
docker cp etl_censo_dump.sql etl_postgres:/tmp/
docker exec -i etl_postgres psql -U etl_user -f /tmp/etl_censo_dump.sql
```

### Estrutura do Banco

**Bronze** (8 tabelas - 1.381 registros):
- populacao_sexo, populacao_cor_raca, nivel_instrucao
- crescimento_populacional, populacao_situacao_domicilio
- caracteristicas_domicilios, territorio, censo_trabalhadores

**Silver** (9 tabelas - 1.410 registros):
- Dimensões: dim_uf, dim_sexo, dim_cor_raca, dim_nivel_instrucao
- Fatos: fato_trabalho, fato_crescimento_populacional, fato_territorio, fato_caracteristicas_domicilio, fato_demografico

**Gold** (7 tabelas - 55 registros):
- Dimensões: dim_tempo, dim_localidade, dim_demografica
- Fatos: fato_indicadores_renda, fato_indicadores_demograficos, fato_crescimento_desenvolvimento, fato_qualidade_vida

## Configurações

### Variáveis de Ambiente
```bash
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=etl_censo
POSTGRES_USER=etl_user
POSTGRES_PASSWORD=etl_password
```

### Recursos Spark
```python
spark.driver.memory=4g
spark.executor.memory=2g
```

## Validação

### Verificar Tabelas

```sql
-- Contar tabelas por schema
SELECT table_schema, COUNT(*) as total
FROM information_schema.tables
WHERE table_schema IN ('bronze', 'silver', 'gold')
GROUP BY table_schema;

-- Verificar registros principais
SELECT 'bronze.censo_trabalhadores' as tabela, COUNT(*) FROM bronze.censo_trabalhadores
UNION ALL
SELECT 'silver.fato_trabalho', COUNT(*) FROM silver.fato_trabalho
UNION ALL
SELECT 'gold.fato_indicadores_renda', COUNT(*) FROM gold.fato_indicadores_renda;
```

### Health Check

```bash
# Verificar status dos containers
docker-compose ps

# Ver logs
docker-compose logs -f

# Parar containers
docker-compose down
```

## Orquestração com Airflow

O projeto inclui DAGs configurados para execução automatizada:

- `censo_etl_pipeline.py` - Pipeline principal (Bronze -> Silver -> Gold)
- `censo_monitoring.py` - Monitoramento de qualidade dos dados

Os DAGs são executados automaticamente quando o Airflow é iniciado via `docker-compose up -d`.

## Documentação Adicional

- `ANALISE_INDICADORES.md` - Análise detalhada dos 5 indicadores selecionados com insights, validações e contexto socioeconômico
- `CHANGELOG.md` - Histórico de mudanças do projeto
- `docs/README.md` - Documentação técnica detalhada

## Metodologia

### Dados Sintéticos

Devido à limitação dos dados públicos disponíveis para rendimento, foram gerados dados sintéticos baseados em distribuições estatísticas conhecidas do IBGE, mantendo coerência com:
- Percentuais oficiais de distribuição de renda por faixa salarial
- Distribuição regional conforme dados do Censo
- Gap salarial por sexo e cor/raça documentados

### Validação dos Resultados

Os indicadores calculados foram comparados com dados oficiais do IBGE para validação:
- Percentual até 1 SM: ~37% (alinhado com IBGE)
- Gap salarial M/F: ~20% (alinhado com estudos oficiais)
- Distribuição regional: coerente com histórico do IBGE

## Nomenclatura e Boas Práticas

### Padrões Utilizados

- **Schemas**: snake_case (bronze, silver, gold)
- **Tabelas**: snake_case com prefixos (dim_, fato_)
- **Colunas**: snake_case descritivo
- **Notebooks**: nome_camada.ipynb
- **Funções Python**: snake_case
- **Classes Python**: PascalCase

### Qualidade do Código

- Modularização em src/utils para reutilização
- Documentação inline nos notebooks
- Separação clara de responsabilidades por camada
- Tratamento de erros e validações
- Logs estruturados para debugging

## Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

---

**Pipeline ETL/ELT Censo 2022**  
Desenvolvido para análise de dados demográficos brasileiros  
Outubro 2025
