A sample project to run dags using airflow on docker

>> install docker on your machine
>> at root dir
>> docker-compose up airflow-init
>> docker-compose up -d
>> check docker ps
>> visit site "localhost:8080" on your browser

### Linting 

Setup dbt profile with `dev`, in root directory: ~/.dbt
Install sqlfliff 
- pip install sqlfluff sqlfluff-templater-dbt
- sqlfluff lint <path to model>
- sqlfluff fix <path to model>