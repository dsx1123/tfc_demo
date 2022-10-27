module "interfaces" {
  source      = "./modules/interface"
  inventory   = var.inventory
  fabric_name = var.fabric_name
  loopbacks   = var.loopbacks
  vpcs        = var.vpcs
}

module "overlay" {
  depends_on  = [module.interfaces]
  source      = "./modules/overlay"
  fabric_name = var.fabric_name
  inventory   = var.inventory
  vrfs        = var.vrfs
  networks    = var.networks
}
