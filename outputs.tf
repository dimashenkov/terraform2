# ----root/outputs.tf------

output "Bucket Name" {
    value = "${module.storage.bucketname}"
}