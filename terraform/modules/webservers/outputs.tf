# IPFS
output "ipfs_public_ip" {
    description = "IP of IPFS instance"
    value = module.ipfs.public_ip
}

output "ipfs_public_dns" {
    description = "DNS of IPFS instance"
    value = module.ipfs.public_dns
}