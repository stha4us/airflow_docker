import os
import sys
from airflow.models import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago

currentdir = os.path.dirname(os.path.abspath(__name__))
parentdir = os.path.dirname(currentdir)
sys.path.append(parentdir)

args = {
    'owner': 'Utsab Shrestha',
    'start_date': days_ago(1) # make start date in the past
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

    run_this_task >> run_this_task_again