output "k8s_ip_addr" {
  value = azurerm_linux_virtual_machine.k8s-node[*].private_ip_address
}

resource "local_file" "inventory" {
 content = <<-EOC
	[control]
	%{ for ip in ${azurerm_linux_virtual_machine.k8s-node[*].private_ip_address} ~}
	${ip}
	%{ endfor ~}
	
EOC

 filename = "inventory"
}
