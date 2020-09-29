output "key_name" {
  value = aws_key_pair.vault.key_name
}

output "public_key" {
  value = tls_private_key.default.public_key_pem
}

output "private_key" {
  value = tls_private_key.default.private_key_pem
}

output "primary_public_ip" {
  value = aws_eip.vault_primary.public_ip
}

output "secondary_public_ip" {
  value = aws_eip.vault_secondary.public_ip
}