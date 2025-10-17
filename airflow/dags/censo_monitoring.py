"""
DAG para Monitoramento do Pipeline ETL Censo 2022
Verifica a saúde dos dados e gera alertas
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.dummy import DummyOperator
from airflow.operators.email import EmailOperator
import pandas as pd
from sqlalchemy import create_engine, text

# Configurações padrão do DAG
default_args = {
    'owner': 'etl_team',
    'depends_on_past': False,
    'start_date': datetime(2025, 1, 1),
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'catchup': False
}

# Definição do DAG
dag = DAG(
    'censo_monitoring',
    default_args=default_args,
    description='Monitoramento e alertas do pipeline ETL Censo 2022',
    schedule_interval='0 6 * * *',  # Executa às 6h da manhã
    max_active_runs=1,
    tags=['censo', 'monitoring', 'alerts']
)

def check_data_quality():
    """Verifica a qualidade dos dados"""
    engine = create_engine('postgresql+psycopg2://etl_user:etl_password@db:5432/etl_censo')
    
    issues = []
    
    with engine.connect() as conn:
        # Verificar se as tabelas têm dados
        tables_to_check = [
            ('bronze', 'populacao_sexo'),
            ('silver', 'fato_trabalho'),
            ('gold', 'fato_indicadores_renda')
        ]
        
        for schema, table in tables_to_check:
            result = conn.execute(text(f"SELECT COUNT(*) FROM {schema}.{table}")).fetchone()
            count = result[0]
            
            if count == 0:
                issues.append(f"Tabela {schema}.{table} está vazia")
            else:
                print(f"✅ {schema}.{table}: {count} registros")
        
        # Verificar indicadores críticos
        result = conn.execute(text("""
            SELECT 
                AVG(percentual_ate_1sm) as avg_ate_1sm,
                AVG(rendimento_medio_uf) as avg_rendimento
            FROM gold.fato_indicadores_renda
        """)).fetchone()
        
        if result:
            avg_ate_1sm, avg_rendimento = result
            if avg_ate_1sm > 50:
                issues.append(f"Percentual de trabalhadores até 1 SM muito alto: {avg_ate_1sm:.2f}%")
            if avg_rendimento < 1000:
                issues.append(f"Rendimento médio muito baixo: R$ {avg_rendimento:.2f}")
    
    if issues:
        raise Exception(f"Problemas de qualidade encontrados: {'; '.join(issues)}")
    
    print("✅ Qualidade dos dados verificada com sucesso")
    return True

def generate_daily_report():
    """Gera relatório diário dos indicadores"""
    engine = create_engine('postgresql+psycopg2://etl_user:etl_password@db:5432/etl_censo')
    
    with engine.connect() as conn:
        # Buscar indicadores principais
        result = conn.execute(text("""
            SELECT 
                uf,
                percentual_ate_1sm,
                percentual_mais_5sm,
                rendimento_medio_uf,
                indice_gini
            FROM gold.fato_indicadores_renda
            ORDER BY rendimento_medio_uf DESC
            LIMIT 10
        """)).fetchall()
        
        print("\n📊 TOP 10 UFs POR RENDIMENTO MÉDIO:")
        print("=" * 80)
        for row in result:
            print(f"{row[0]:2s} | {row[1]:6.2f}% | {row[2]:6.2f}% | R$ {row[3]:8,.2f} | {row[4]:.4f}")
        
        # Estatísticas gerais
        stats = conn.execute(text("""
            SELECT 
                AVG(percentual_ate_1sm) as avg_ate_1sm,
                AVG(percentual_mais_5sm) as avg_mais_5sm,
                AVG(rendimento_medio_uf) as avg_rendimento,
                AVG(indice_gini) as avg_gini
            FROM gold.fato_indicadores_renda
        """)).fetchone()
        
        print(f"\n📈 ESTATÍSTICAS GERAIS:")
        print(f"Trabalhadores até 1 SM: {stats[0]:.2f}%")
        print(f"Trabalhadores > 5 SM: {stats[1]:.2f}%")
        print(f"Rendimento médio: R$ {stats[2]:,.2f}")
        print(f"Índice de Gini médio: {stats[3]:.4f}")
    
    return True

# Tarefas do DAG

start_monitoring = DummyOperator(
    task_id='start_monitoring',
    dag=dag
)

check_quality = PythonOperator(
    task_id='check_data_quality',
    python_callable=check_data_quality,
    dag=dag
)

generate_report = PythonOperator(
    task_id='generate_daily_report',
    python_callable=generate_daily_report,
    dag=dag
)

end_monitoring = DummyOperator(
    task_id='end_monitoring',
    dag=dag
)

# Dependências
start_monitoring >> check_quality >> generate_report >> end_monitoring

