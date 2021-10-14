resource "local_file" "secrets" {
 content = <<-EOT
	subscription_id: "${var.subscription_id}"
	tenant_id: "${var.tenant_id}"
	client_id: "${var.client_id}"
	client_secret: "${var.client_secret}"
	acr_url: "${azurerm_container_registry.acr.login_server}"
EOT
 filename = "creds/ansible.tfvars"
}

