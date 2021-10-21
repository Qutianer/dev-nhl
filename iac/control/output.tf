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

resource "local_file" "private_ip_address" {
 content = "${azurerm_linux_virtual_machine.control.private_ip_address}"
 filename = "private_ip_address"
}



