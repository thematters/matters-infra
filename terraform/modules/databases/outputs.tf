# database url
output "db_instance_address" {
    description = "Database URL"
    value = module.db.this_db_instance_address   
}