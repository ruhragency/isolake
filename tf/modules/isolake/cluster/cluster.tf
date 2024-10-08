// Cluster with latest version and derby spark configs

resource "databricks_cluster" "example" {
  cluster_name       = "Private Databricks Example Cluster Managed by TF"
  spark_version      = "15.4.x-scala2.12"
  node_type_id       = "i3.xlarge"
  data_security_mode = "USER_ISOLATION"
  is_pinned = true
  autotermination_minutes = 10
  autoscale {
    min_workers = 1
    max_workers = 2
  }
  spark_conf = {
    "spark.hadoop.javax.jdo.option.ConnectionUserName"   = "admin"
    "spark.hadoop.javax.jdo.option.ConnectionURL"        = "jdbc:derby:memory:myInMemDB;create=true"
    "spark.hadoop.javax.jdo.option.ConnectionDriverName" = "org.apache.derby.jdbc.EmbeddedDriver"
    "spark.databricks.python.version" = "3.11.0rc1"

    # Set environment variable for region
    "spark.executorEnv.REGION" = var.region
    "spark.driverEnv.REGION"   = var.region
  }
  init_scripts {
  s3 {
    destination = "s3://private-databricks-data-bucket/init-scripts/databricks_cluster_vpn_setup.sh"
    region      = var.region
    }
  }
}
