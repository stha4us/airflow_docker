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

## BigQuery ML part
### Prerequisites

1. **GCP Project** with BigQuery API enabled
2. **BigQuery ML API** enabled
3. **dbt-bigquery** adapter installed:
   ```bash
   pip install dbt-bigquery
   ```
4. GCP authentication set up:
   ```bash
   gcloud auth application-default login
   ```

---

### Setup

### 1. Configure your project

In `dbt_project.yml`, add your GCP project ID under `vars`:

```yaml
vars:
  gcp_project: "your-gcp-project-id"
```

### 2. Set up your profile

Copy `profiles.yml.sample` contents to `~/.dbt/profiles.yml` and update:
- `project:` → GCP project ID
- `dataset:` → desired BigQuery dataset prefix (e.g. `iris`)
- `location:` → your BigQuery region (e.g. `australia-southeast1`)

