variable "subdomain" {
  type = string
}
variable "domain" {
  type = string
}
variable "db_table_name" {
  type = string
  default = "PortfolioViewsTf"
}
variable "api_gateway_name" {
  type = string
  default = "Portfolio-Views-Rest-Api-Tf"
}