output "k8s_public_ip_addr" {
  value = azurerm_linux_virtual_machine.k8s-node[*].ip_address
}

resource "local_file" "inventory" {
 content = <<-EOC
	[control]
	${azurerm_linux_virtual_machine.k8s-node[*].ip_address}
EOC

 filename = "inventory"
}
