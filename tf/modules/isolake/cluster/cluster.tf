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
#   spark_conf = {
#     "spark.hadoop.javax.jdo.option.ConnectionUserName"   = "admin"
#     "spark.hadoop.javax.jdo.option.ConnectionURL"        = "jdbc:derby:memory:myInMemDB;create=true"
#     "spark.hadoop.javax.jdo.option.ConnectionDriverName" = "org.apache.derby.jdbc.EmbeddedDriver"
#     "spark.databricks.python.version" = "3.11.0rc1"
#   }
  init_scripts {
  volumes {
    destination = "/Volumes/main/test/test_volumne/databricks_cluster_vpn_setup.sh"
    }
  }
}
