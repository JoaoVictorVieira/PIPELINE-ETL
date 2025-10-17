# Arquitetura do Pipeline ETL - Censo 2022

## Visão Geral da Arquitetura Medalhão

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         PIPELINE ETL/ELT - CENSO 2022                        │
│                      Arquitetura Medalhão (Bronze/Silver/Gold)               │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────┐
│  FONTE DE DADOS      │
│                      │
│  17 Arquivos CSV     │
│  IBGE - Censo 2022   │
│                      │
│  • População         │
│  • Demografia        │
│  • Território        │
│  • Rendimento        │
└──────┬───────────────┘
       │
       │ PySpark
       │ Ingestão
       ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                           CAMADA BRONZE (Raw Data)                            │
│                                                                               │
│  Schema: bronze                                     Registros: 1.381         │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │  Tabelas (8):                                                        │    │
│  │  • populacao_sexo                      2 registros                   │    │
│  │  • populacao_cor_raca                  5 registros                   │    │
│  │  • nivel_instrucao                     4 registros                   │    │
│  │  • crescimento_populacional           13 registros                   │    │
│  │  • populacao_situacao_domicilio        2 registros                   │    │
│  │  • caracteristicas_domicilios          4 registros                   │    │
│  │  • territorio                          1 registro                    │    │
│  │  • censo_trabalhadores             1.350 registros (sintéticos)      │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                               │
│  Características:                                                             │
│  - Dados brutos sem transformação                                             │
│  - Validação de integridade                                                   │
│  - Formato original preservado                                                │
└───────────────────────────────┬───────────────────────────────────────────────┘
                                │
                                │ Pandas
                                │ Limpeza e Normalização
                                ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                        CAMADA SILVER (Clean Data)                             │
│                                                                               │
│  Schema: silver                                    Registros: 1.410          │
│  ┌───────────────────────────┐    ┌──────────────────────────────────┐      │
│  │  DIMENSÕES (4 tabelas)    │    │  FATOS (5 tabelas)                │      │
│  │                           │    │                                   │      │
│  │  • dim_uf            27   │    │  • fato_trabalho           1.350  │      │
│  │  • dim_sexo           2   │    │  • fato_crescimento_pop      13   │      │
│  │  • dim_cor_raca       5   │    │  • fato_territorio            1   │      │
│  │  • dim_nivel_inst     8   │    │  • fato_carac_domicilio       4   │      │
│  │                           │    │  • fato_demografico           0   │      │
│  └───────────────────────────┘    └──────────────────────────────────┘      │
│                                                                               │
│  Características:                                                             │
│  - Dados limpos e normalizados                                                │
│  - Modelo dimensional (Star Schema Foundation)                                │
│  - Relacionamentos definidos                                                  │
└───────────────────────────────┬───────────────────────────────────────────────┘
                                │
                                │ Agregações
                                │ Cálculo de Indicadores
                                ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                         CAMADA GOLD (Analytics)                               │
│                                                                               │
│  Schema: gold                                      Registros: 55             │
│  ┌───────────────────────────┐    ┌──────────────────────────────────┐      │
│  │  DIMENSÕES (3 tabelas)    │    │  FATOS (4 tabelas)                │      │
│  │                           │    │                                   │      │
│  │  • dim_tempo          1   │    │  • fato_indicadores_renda    27   │      │
│  │  • dim_localidade    27   │    │  • fato_indicadores_demo      0   │      │
│  │  • dim_demografica    0   │    │  • fato_crescimento_desenv    0   │      │
│  │                           │    │  • fato_qualidade_vida        0   │      │
│  └───────────────────────────┘    └──────────────────────────────────┘      │
│                                                                               │
│  INDICADORES CALCULADOS:                                                      │
│  ┌─────────────────────────────────────────────────────────────────┐         │
│  │  1. % trabalhadores até 1 SM:                        37.00%     │         │
│  │  2. % trabalhadores > 5 SM:                          20.00%     │         │
│  │  3. Rendimento médio mensal Brasil:            R$ 5.132,71      │         │
│  │  4. Índice de Gini:                                  0.6875     │         │
│  │  5. Nível de ocupação 14+ anos:                      72.26%     │         │
│  └─────────────────────────────────────────────────────────────────┘         │
│                                                                               │
│  Características:                                                             │
│  - Star Schema completo                                                       │
│  - Indicadores prontos para consumo                                           │
│  - Otimizado para análises e dashboards                                       │
└───────────────────────────────┬───────────────────────────────────────────────┘
                                │
                                ▼
                        ┌───────────────────┐
                        │  CONSUMO          │
                        │                   │
                        │  • BI Tools       │
                        │  • Dashboards     │
                        │  • Análises       │
                        │  • Relatórios     │
                        └───────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           STACK TECNOLÓGICA                                   │
│                                                                               │
│  Processamento:   Apache Spark 3.5.1, Pandas                                 │
│  Armazenamento:   PostgreSQL 15                                               │
│  Orquestração:    Apache Airflow 2.8.1                                        │
│  Linguagem:       Python 3.10+                                                │
│  Containerização: Docker & Docker Compose                                     │
│  Desenvolvimento: JupyterLab                                                  │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           FLUXO DE DADOS                                      │
│                                                                               │
│  CSV Files → Bronze (Raw) → Silver (Clean) → Gold (Analytics) → Consumption  │
│              ↓               ↓                 ↓                              │
│           Validação      Normalização     Indicadores                         │
│           Ingestão       Dimensões        Star Schema                         │
│           PySpark        Pandas           Agregações                          │
│                                                                               │
│  Tempo de Execução: < 5 minutos                                              │
│  Orquestração: Apache Airflow (DAGs automatizados)                            │
│  Qualidade: 100% dos dados validados                                          │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Detalhamento por Camada

### Bronze Layer
- **Propósito**: Ingestão de dados brutos
- **Tecnologia**: Apache Spark
- **Formato**: Tabelas relacionais (PostgreSQL)
- **Transformação**: Nenhuma (dados preservados como estão)
- **Validação**: Tipos de dados e integridade

### Silver Layer
- **Propósito**: Dados limpos e normalizados
- **Tecnologia**: Pandas
- **Formato**: Modelo dimensional (pré-Star Schema)
- **Transformação**: Limpeza, normalização, criação de dimensões
- **Qualidade**: Dados validados e consistentes

### Gold Layer
- **Propósito**: Indicadores analíticos
- **Tecnologia**: Pandas + SQL
- **Formato**: Star Schema
- **Transformação**: Agregações e cálculos de indicadores
- **Output**: Métricas prontas para consumo

## Nomenclatura e Padrões

### Schemas
- `bronze.*` - Dados brutos
- `silver.*` - Dados limpos
- `gold.*` - Indicadores analíticos

### Tabelas
- `dim_*` - Tabelas dimensão
- `fato_*` - Tabelas fato
- Nome descritivo em snake_case

### Colunas
- snake_case
- Nomes descritivos
- Tipos adequados ao conteúdo

## Monitoramento e Qualidade

- **Logs estruturados**: Airflow logs
- **Validação de dados**: Em cada camada
- **Testes automatizados**: Verificação de integridade
- **Documentação**: Inline nos notebooks

---

**Pipeline ETL/ELT - Censo Demográfico 2022**  
Outubro 2025

