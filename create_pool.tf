variable  "ip_pool_1" {
  type = map

  default={
  network="9.10.50.0"
  gateway="9.10.50.1"
}
}
variable  "ip_pool_2" {
  type = map

  default={
  network="9.10.51.0"
  gateway="9.10.51.1"
}
}

variable  "ip_pool_3" {
  type = map

  default={
  network="9.10.52.0"
  gateway="9.10.52.1"
}
}



resource "dnacenter_global_pool" "response" {
  provider = dnacenter
  depends_on = [dnacenter_site.bld0]
  parameters {
    settings {
      ippool {
        ip_address_space = "IPv4"
        ip_pool_cidr     = "9.10.0.0/16" /* <======== replace the subnet with your choice */
        ip_pool_name     = "tform-1"
        type             = "Generic"
      }
    }
  }
}



resource "dnacenter_reserve_ip_subpool" "example" {
  count=1
  depends_on = [dnacenter_global_pool.response]
  provider = dnacenter
  parameters {
    ipv4_global_pool = "9.10.0.0/16"
     type               = "Generic"
    ipv4_dhcp_servers  = ["9.1.0.21"]
    ipv4_dns_servers   = ["9.1.0.21"]
    ipv4_gate_way      = var.ip_pool_1["gateway"]
    ipv4_prefix        = "true"
    ipv4_prefix_length = "24"
    ipv4_subnet        =  var.ip_pool_1["network"]
    name    = "tform-reserve-${count.index+1}"
    site_id = data.dnacenter_site.example1.items[0].id

    }
  }


  resource "dnacenter_reserve_ip_subpool" "example1" {
    count=1
    depends_on = [dnacenter_global_pool.response]
    provider = dnacenter
    parameters {
      ipv4_global_pool = "9.10.0.0/16"
       type               = "Generic"
      ipv4_dhcp_servers  = ["9.1.0.21"]
      ipv4_dns_servers   = ["9.1.0.21"]
      ipv4_gate_way      = var.ip_pool_2["gateway"]
      ipv4_prefix        = "true"
      ipv4_prefix_length = "24"
      ipv4_subnet        =  var.ip_pool_2["network"]
      name    = "tform-reserve-2"
      site_id = data.dnacenter_site.example1.items[0].id

      }
    }
