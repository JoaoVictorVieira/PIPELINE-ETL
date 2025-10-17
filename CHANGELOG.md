# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [1.0.0] - 2025-10-17

### Adicionado
- Pipeline ETL/ELT completo para dados do Censo Demográfico 2022
- Arquitetura Medalhão (Bronze/Silver/Gold) implementada
- 5 indicadores socioeconômicos calculados automaticamente
- Apache Airflow para orquestração de workflows
- Apache Spark para processamento distribuído
- PostgreSQL como banco de dados principal
- Docker Compose para containerização completa
- JupyterLab para desenvolvimento e análise
- Sistema de monitoramento com health checks
- Documentação completa técnica e de execução
- Scripts de automação para deployment e manutenção
- Testes automatizados para validação do pipeline
- Configurações centralizadas e variáveis de ambiente
- Logs estruturados e sistema de alertas
- Dumps do banco de dados em múltiplos formatos

### Características Técnicas
- Bronze Layer: Ingestão de 17 arquivos CSV do Censo 2022
- Silver Layer: Limpeza, normalização e criação de dimensões
- Gold Layer: Cálculo de indicadores com Star Schema
- Dados Sintéticos: Geração realista de dados de rendimento
- Validação de Qualidade: Verificação automática de integridade
- Performance: Pipeline executa em menos de 5 minutos
- Escalabilidade: Configuração para diferentes ambientes

### Indicadores Implementados
1. Percentual de trabalhadores até 1 salário mínimo
2. Percentual de trabalhadores com rendimentos superiores a 5 salários mínimos
3. Rendimento nominal médio mensal de todos os trabalhos
4. Índice de Gini (Brasil e regiões)
5. Nível de ocupação da população com 14 anos ou mais

### Arquivos Principais
- `notebooks/bronze.ipynb` - Camada Bronze
- `notebooks/silver.ipynb` - Camada Silver  
- `notebooks/gold.ipynb` - Camada Gold
- `airflow/dags/censo_etl_pipeline.py` - DAG principal
- `airflow/dags/censo_monitoring.py` - DAG de monitoramento
- `sql/init_schemas.sql` - Schemas do banco

### Documentação
- `README.md` - Documentação principal do projeto
- `ANALISE_INDICADORES.md` - Análise detalhada dos 5 indicadores
- `DUMPS_README.md` - Guia de dumps e restauração
- `CHANGELOG.md` - Este arquivo

### Configuração
- `docker-compose.yml` - Orquestração de containers
- `Dockerfile` - Imagem customizada
- `requirements.txt` - Dependências Python
- `sql/init_schemas.sql` - Schemas do banco

### Scripts Utilitários
- `start_airflow.py` - Inicialização automática do Airflow
- `test_pipeline.py` - Teste de validação do pipeline
- `run_pipeline.py` - Execução programática dos notebooks
- `verify_dump.py` - Verificação de dumps do banco
- `restore_dump.bat` - Restauração de dumps (Windows)
- `restore_dump.sh` - Restauração de dumps (Linux/Mac)

### Dumps do Banco de Dados
- `etl_censo_dump.sql` - Dump completo (estrutura + dados)
- `etl_censo_schema.sql` - Apenas estrutura
- `etl_censo_dump.backup` - Formato compactado PostgreSQL

---

## Legenda

- Adicionado para novas funcionalidades
- Modificado para mudanças em funcionalidades existentes
- Depreciado para funcionalidades que serão removidas
- Removido para funcionalidades removidas
- Corrigido para correções de bugs
- Segurança para vulnerabilidades corrigidas
