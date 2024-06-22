# これは何

問題調査用リポジトリ

- cloud build上で動かすdbt-bigqueryからスプレッドシートへアクセスできない
  - dbt runの中でselect文を発行する箇所でエラーが出る
    - `BigQuery error: Access Denied: BigQuery BigQuery: Permission denied while getting Drive credentials.`
  - テーブル定義クエリの中でpivotテーブルを作成する際に軸をdbt_utils.get_column_values()で取得する
- SAの権限とか見直してもできない

# ライブラリ入れる系のメモ

- poetry new test_access_from_cloudbuild_dbt
  - このディレクトリができる
  - 以降はこの中で作業
- poetry add dbt-bigquery sqlfluff
- poetry run dbt init
  - BQ, oauthを選択
  - また新たにディレクトリが作られその中に一式できる
  - project名とかdataset名とか入力したけどコードに存在しない謎
  - datasetはdbt_project.ymlのmodels.project名.models配下のディレクトリ名.schemaに定義
- git initしてfirst commit
- terraform書いてterraform init & apply
  - お試しなのでstateはlocalでcommitしない
