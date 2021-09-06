output "control_public_ip_addr" {
  value = azurerm_linux_virtual_machine.control.public_ip_address
}

resource "local_file" "inventory" {
 content = <<-EOC
	[control]
	${azurerm_linux_virtual_machine.control.public_ip_address}
EOC

 filename = "inventory"
}
