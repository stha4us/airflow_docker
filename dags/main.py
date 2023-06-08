import os
import sys
from airflow.models import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
from datetime import datetime
from datetime import timedelta

currentdir = os.path.dirname(os.path.abspath(__name__))
parentdir = os.path.dirname(currentdir)
sys.path.append(parentdir)

args = {
    'owner': 'Utsab Shrestha',
    'start_date': days_ago(1) # make start date in the past
}

dbt_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2022, 10, 23),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 3,
    'retry_delay': timedelta(minutes=5)
}

def run_this_func():
    print('I am coming first')

def run_second_func():
    print('I am coming second')

#defining the dag object
dag = DAG(
    dag_id='sample',
    default_args=args,
    schedule_interval='@daily' #to make this workflow happen every day
)

dbt_dag = DAG(
    'dbt',
    default_args=dbt_args,
    description='DAG in charge of running DBT and uploading to data store',
    schedule_interval='0 19 * * *',
)

#assigning the task for our dag to do
with dag:
    run_this_task = PythonOperator(
        task_id='run_this_first',
        python_callable = run_this_func
    )

    run_this_task_again = PythonOperator(
        task_id='run_this_second',
        python_callable=run_second_func,
    )

    dbt_run = BashOperator(
    task_id='dbt_run',
    bash_command='cd /opt/airflow/dbt && dbt run',
    dag=dag
)

    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command='cd /opt/airflow/dbt && dbt test',
        dag=dag
    )


    run_this_task >> run_this_task_again

    dbt_run >> dbt_test