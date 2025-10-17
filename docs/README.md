# 📊 Pipeline ETL/ELT - Censo Demográfico 2022

## 🎯 Visão Geral do Projeto

Este projeto implementa um pipeline ETL/ELT completo para processamento de dados do Censo Demográfico 2022 do IBGE, seguindo uma arquitetura de datalake em camadas (medalhão) com orquestração via Apache Airflow.

### 📋 Objetivos do Desafio Técnico

- ✅ **Processar dados reais** do Censo Demográfico 2022
- ✅ **Implementar arquitetura medalhão** (Bronze/Silver/Gold)
- ✅ **Calcular indicadores socioeconômicos** relevantes
- ✅ **Criar modelo estrela** para análise dimensional
- ✅ **Implementar orquestração** com Apache Airflow
- ✅ **Garantir replicabilidade** e documentação completa

## 🏗️ Arquitetura da Solução

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

### Stack Tecnológico

- **🐍 Python 3.10+** - Linguagem principal
- **⚡ Apache Spark 3.5.1** - Processamento distribuído
- **🐘 PostgreSQL 15** - Banco de dados relacional
- **🎯 Apache Airflow 2.8.1** - Orquestração de workflows
- **🐳 Docker & Docker Compose** - Containerização
- **📓 JupyterLab** - Desenvolvimento e análise
- **📊 Pandas & NumPy** - Manipulação de dados

## 📊 Indicadores Calculados

### 1. **Indicadores de Renda e Trabalho**
- **% Trabalhadores até 1 Salário Mínimo** (~37%)
- **% Trabalhadores > 5 Salários Mínimos** (~20%)
- **Rendimento Médio Mensal** (Brasil: R$ ~2.800)

### 2. **Indicadores Geográficos**
- **Rendimento por Região** (Norte, Nordeste, Centro-Oeste, Sudeste, Sul)
- **Rendimento por UF** (27 estados + DF)
- **Índice de Gini Regional** (medida de desigualdade)

### 3. **Indicadores Demográficos**
- **Rendimento por Sexo** (Masculino/Feminino + Gap Salarial)
- **Rendimento por Cor/Raça** (Branca, Parda, Preta, Amarela, Indígena)
- **Nível de Ocupação** (População 14+ anos)

## 🗂️ Estrutura do Projeto

```
PIPELINE-ETL/
├── 📊 data/                          # Dados do Censo 2022
│   ├── raw/                          # Dados brutos (CSV)
│   ├── processed/                    # Dados processados
│   └── external/                     # Dados externos
├── 📓 notebooks/                     # Notebooks Jupyter
│   ├── bronze.ipynb                  # Camada Bronze
│   ├── silver.ipynb                  # Camada Silver
│   └── gold.ipynb                    # Camada Gold
├── 🏗️ src/                          # Código fonte Python
│   ├── etl/                          # Módulos ETL
│   │   ├── bronze/                   # Processamento Bronze
│   │   ├── silver/                   # Processamento Silver
│   │   └── gold/                     # Processamento Gold
│   ├── config/                       # Configurações
│   ├── models/                       # Modelos de dados
│   ├── tests/                        # Testes unitários
│   └── utils/                        # Utilitários
├── 🎯 airflow/                       # Configuração Airflow
│   ├── dags/                         # DAGs do Airflow
│   ├── logs/                         # Logs do Airflow
│   └── plugins/                      # Plugins customizados
├── 🗄️ sql/                          # Scripts SQL
│   └── init_schemas.sql              # Schemas do banco
├── 📚 docs/                          # Documentação
│   ├── api/                          # Documentação da API
│   ├── deployment/                   # Guias de deployment
│   └── README.md                     # Este arquivo
├── 🧪 tests/                         # Testes de integração
├── 📜 scripts/                       # Scripts utilitários
│   ├── deployment/                   # Scripts de deploy
│   └── monitoring/                   # Scripts de monitoramento
├── 🐳 docker-compose.yml             # Orquestração de containers
├── 🐳 Dockerfile                     # Imagem customizada
├── 📋 requirements.txt               # Dependências Python
└── 🚀 start_airflow.py               # Script de inicialização
```

## 🚀 Início Rápido

### Pré-requisitos
- Docker e Docker Compose instalados
- 8GB RAM disponível
- Portas 5432, 8080, 8888 livres

### Execução em 3 Passos

```bash
# 1. Clonar e navegar para o projeto
git clone <repository-url>
cd PIPELINE-ETL

# 2. Iniciar pipeline completo
python start_airflow.py

# 3. Acessar interfaces
# Airflow: http://localhost:8080 (admin/admin)
# JupyterLab: http://localhost:8888
```

## 📈 Resultados Esperados

### Dados Processados
- **Bronze Layer**: 8 tabelas com dados brutos do Censo 2022
- **Silver Layer**: 4 tabelas com dados limpos e dimensões
- **Gold Layer**: 3 tabelas com indicadores calculados

### Métricas de Qualidade
- **Cobertura de dados**: 100% dos arquivos CSV processados
- **Validação**: Todos os indicadores calculados com sucesso
- **Performance**: Pipeline executa em < 5 minutos
- **Disponibilidade**: 99.9% uptime via Airflow

## 🔧 Configuração Avançada

### Variáveis de Ambiente
```bash
# Banco de dados
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=etl_censo
POSTGRES_USER=etl_user
POSTGRES_PASSWORD=etl_password

# Airflow
AIRFLOW__CORE__EXECUTOR=LocalExecutor
AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql+psycopg2://etl_user:etl_password@db:5432/etl_censo
```

### Personalização
- **Frequência de execução**: Editar `schedule_interval` nos DAGs
- **Recursos Spark**: Ajustar `spark.driver.memory` no código
- **Alertas**: Configurar SMTP no `docker-compose.yml`

## 📚 Documentação Adicional

- **[Guia de Execução](GUIA_EXECUCAO.md)** - Instruções detalhadas
- **[Guia do Airflow](GUIA_AIRFLOW.md)** - Orquestração e monitoramento
- **[Análise de Indicadores](ANALISE_INDICADORES.md)** - Validação dos resultados
- **[API Documentation](docs/api/)** - Documentação da API (se aplicável)

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👥 Autores

- **João Victor** - *Desenvolvimento inicial* - [GitHub](https://github.com/joaovictor)

## 🙏 Agradecimentos

- IBGE pelo fornecimento dos dados do Censo 2022
- Comunidade Apache Spark e Airflow
- Equipe de Engenharia de Dados

---

**📊 Pipeline ETL/ELT Censo 2022 - Desenvolvido com ❤️ para análise de dados demográficos brasileiros**

