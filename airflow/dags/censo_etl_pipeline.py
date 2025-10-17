"""
DAG para Pipeline ETL Censo 2022
Orquestra a execução dos notebooks Bronze, Silver e Gold
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.operators.dummy import DummyOperator
from airflow.sensors.filesystem import FileSensor
import os

# Configurações padrão do DAG
default_args = {
    'owner': 'etl_team',
    'depends_on_past': False,
    'start_date': datetime(2025, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'catchup': False
}

# Definição do DAG
dag = DAG(
    'censo_etl_pipeline',
    default_args=default_args,
    description='Pipeline ETL para dados do Censo 2022',
    schedule_interval='@daily',  # Executa diariamente
    max_active_runs=1,
    tags=['censo', 'etl', 'brasil']
)

# Função para verificar se os dados estão disponíveis
def check_data_availability():
    """Verifica se os arquivos CSV estão disponíveis"""
    data_dir = "/app/data"
    required_files = [
        "Censo 2022 - População por sexo - Brasil.csv",
        "Censo 2022 - População por cor ou raça - Brasil.csv",
        "Censo 2022 - Nível de instrução - Brasil.csv"
    ]
    
    missing_files = []
    for file in required_files:
        if not os.path.exists(os.path.join(data_dir, file)):
            missing_files.append(file)
    
    if missing_files:
        raise FileNotFoundError(f"Arquivos não encontrados: {missing_files}")
    
    print("✅ Todos os arquivos de dados estão disponíveis")
    return True

# Função para executar teste do pipeline
def test_pipeline():
    """Executa o teste do pipeline"""
    import subprocess
    result = subprocess.run(
        ["python", "/app/test_pipeline.py"],
        capture_output=True,
        text=True,
        cwd="/app"
    )
    
    if result.returncode != 0:
        raise Exception(f"Teste do pipeline falhou: {result.stderr}")
    
    print("✅ Pipeline testado com sucesso")
    return True

# Tarefas do DAG

# 1. Verificação inicial
start_task = DummyOperator(
    task_id='start',
    dag=dag
)

# 2. Verificar disponibilidade dos dados
check_data = PythonOperator(
    task_id='check_data_availability',
    python_callable=check_data_availability,
    dag=dag
)

# 3. Executar notebook Bronze
bronze_task = BashOperator(
    task_id='execute_bronze_layer',
    bash_command="""
    cd /app && \
    jupyter nbconvert --to notebook --execute notebooks/bronze.ipynb \
    --output bronze_executed.ipynb \
    --ExecutePreprocessor.timeout=600
    """,
    dag=dag
)

# 4. Executar notebook Silver
silver_task = BashOperator(
    task_id='execute_silver_layer',
    bash_command="""
    cd /app && \
    jupyter nbconvert --to notebook --execute notebooks/silver.ipynb \
    --output silver_executed.ipynb \
    --ExecutePreprocessor.timeout=600
    """,
    dag=dag
)

# 5. Executar notebook Gold
gold_task = BashOperator(
    task_id='execute_gold_layer',
    bash_command="""
    cd /app && \
    jupyter nbconvert --to notebook --execute notebooks/gold.ipynb \
    --output gold_executed.ipynb \
    --ExecutePreprocessor.timeout=600
    """,
    dag=dag
)

# 6. Testar pipeline completo
test_pipeline_task = PythonOperator(
    task_id='test_pipeline',
    python_callable=test_pipeline,
    dag=dag
)

# 7. Limpeza de arquivos temporários
cleanup_task = BashOperator(
    task_id='cleanup_temp_files',
    bash_command="""
    cd /app && \
    rm -f *_executed.ipynb && \
    echo "✅ Arquivos temporários removidos"
    """,
    dag=dag
)

# 8. Finalização
end_task = DummyOperator(
    task_id='end',
    dag=dag
)

# Definição das dependências
start_task >> check_data >> bronze_task >> silver_task >> gold_task >> test_pipeline_task >> cleanup_task >> end_task

