
resource "azurerm_dns_zone" "dev" {
  name                = "nhl.appw.ru"
#  resource_group_name = "main"
  resource_group_name = data.azurerm_resource_group.main.name
}
