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
  - profiles.ymlを作成
    - 環境に応じて設定の上書きができる
    - なくてもいいけどあったほうが便利
- git initしてfirst commit
- terraform書いてterraform init & apply
  - お試しなのでstateはlocalでcommitしない
- githubの接続認証
  - Secret Manager APIを有効化
    - 認証情報をsecretに保存するためだとか
  - cloud buildのコンソール -> リポジトリ -> 第二世代 -> リポジトリをリンク
  - cloud buildのコンソール -> トリガー -> リポジトリを接続
  - sample-triggerみたいなのができるけどデフォルトSAなので注意
    - 自分はうっかり作ってしまって使っているが削除していいのかもしれない
- 手動ビルドの実行
  - ここでIAM APIの有効化が必要
- dbtのpackages.yml, profiles.ymlはデフォで存在しないので新規作成
- 手元で作業する場合でもスプレッドシートへのクエリでエラー
  - `BigQuery error: Access Denied: BigQuery BigQuery: Permission denied while getting Drive credentials.`
  - 以下でdrive, spreadsheetもスコープに入れてやる
    - 冗長な定義かもしれないが未検証
    - `gcloud auth application-default login --scopes "https://www.googleapis.com/auth/spreadsheets,https://www.googleapis.com/auth/drive,https://www.googleapis.com/auth/userinfo.email,https://www.googleapis.com/auth/cloud-platform,openid"`

