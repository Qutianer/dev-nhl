
resource "azurerm_dns_zone" "nhl" {
  name                = "nhl.appw.ru"
#  resource_group_name = "main"
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_dns_a_record" "nhl_www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.nhl.name
  resource_group_name = data.azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = data.azurerm_lb.prod.frontend_ip_configuration[1].public_ip_address_id
}

resource "azurerm_dns_a_record" "nhl_dev" {
  name                = "dev"
  zone_name           = azurerm_dns_zone.nhl.name
  resource_group_name = data.azurerm_resource_group.main.name
  ttl                 = 300
  target_resource_id  = data.azurerm_lb.dev.frontend_ip_configuration[1].public_ip_address_id
}

