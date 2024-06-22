data "google_project" "project" {
  project_id = "${var.project_id}"
}

resource "google_cloudbuild_trigger" "service-account-trigger" {
  name = "test-access-ss-from-cloudbuild-dbt"

  source_to_build {
    uri       = "${var.gh_repository_path}"
    ref       = "refs/heads/main"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.yaml"
    uri       = "${var.gh_repository_path}"
    revision  = "refs/heads/main"
    repo_type = "GITHUB"
  }

  service_account = google_service_account.cloudbuild_service_account.id
  depends_on = [
    google_project_iam_member.act_as,
    google_project_iam_member.logs_writer
  ]
}

resource "google_service_account" "cloudbuild_service_account" {
  account_id = "cloud-sa"
}

resource "google_project_iam_member" "bq_job_user" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "bq_data_editor" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "act_as" {
  project = data.google_project.project.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "logs_writer" {
  project = data.google_project.project.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_bigquery_dataset" "external_tables" {
  dataset_id                  = "external_tables"
  friendly_name               = "external_tables"
  description                 = "This is a test description"
  default_table_expiration_ms = 3600000
}

resource "google_bigquery_table" "external_table" {
  dataset_id = google_bigquery_dataset.external_tables.dataset_id
  table_id   = "pivot_target"

  schema = <<EOF
[
  {
    "name": "key_date",
    "type": "DATE",
    "mode": "NULLABLE"
  },
  {
    "name": "axis_data",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "value_data",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF

  external_data_configuration {
    source_format = "GOOGLE_SHEETS"
    autodetect = false

    google_sheets_options {
      skip_leading_rows = 1
    }

    source_uris = [
      "https://docs.google.com/spreadsheets/d/${var.spreadsheet_id}",
    ]
  }
}
