terraform {
  required_providers {
    dnacenter = {
      source  = "cisco-en-programmability/dnacenter"
      version = "0.3.0-beta"
    }
  }
}

variable "username" {
  type    = string
  default = "admin"
}

variable "password" {
  type    = string
  default = "cisco"
}

provider "dnacenter" {
  username   = var.username
  password   = var.password
  base_url   = "https://10.104.233.91"
  debug      = "true"
  ssl_verify = "false" # This needs to be false, if terraform can't trust the certificate of dnacenter
}



resource "dnacenter_site" "example" {
  provider = dnacenter
  parameters {
    site {
      area {
        name        = "sanjose"
        parent_name = "Global"
      }

    }
    type = "area"
  }
}

resource "dnacenter_site" "bld" {
  provider   = dnacenter
  depends_on = [dnacenter_site.example]
  count      = 4
  parameters {
    site {
      building {
        name        = "bld-${count.index}"
        address     = "Cisco - Building 10, 300 E Tasman Dr, San Jose, California 95134, United States"
        parent_name = "Global/sanjose"
        latitude    = 37.338
        longitude   = -121.832

      }
    }
    type = "building"
  }




}


resource "dnacenter_site" "bld1" {
  provider   = dnacenter
  depends_on = [dnacenter_site.example]

  for_each = toset(["f1", "f2", "f3", "f4"])

  parameters {
    site {
      floor {
        height      = 100
        length      = 100
        name        = each.value
        parent_name = "Global/sanjose/bld-1"
        rf_model    = "Indoor High Ceiling"
        width       = 100
      }
    }
    type = "floor"
  }

}

resource "dnacenter_site" "bld2" {
  provider   = dnacenter
  depends_on = [dnacenter_site.example]

  for_each = toset(["f1", "f2", "f3", "f4"])

  parameters {
    site {
      floor {
        height      = 100
        length      = 100
        name        = each.value
        parent_name = "Global/sanjose/bld-2"
        rf_model    = "Indoor High Ceiling"
        width       = 100
      }
    }
    type = "floor"
  }

}
resource "dnacenter_site" "bld3" {
  provider   = dnacenter
  depends_on = [dnacenter_site.example]

  for_each = toset(["f1", "f2", "f3", "f4"])

  parameters {
    site {
      floor {
        height      = 100
        length      = 100
        name        = each.value
        parent_name = "Global/sanjose/bld-3"
        rf_model    = "Indoor High Ceiling"
        width       = 100
      }
    }
    type = "floor"
  }

}



resource "dnacenter_site" "bld0" {
  provider   = dnacenter
  depends_on = [dnacenter_site.example]

  for_each = toset(["f1", "f2", "f3", "f4"])

  parameters {
    site {
      floor {
        height      = 100
        length      = 100
        name        = each.value
        parent_name = "Global/sanjose/bld-0"
        rf_model    = "Indoor High Ceiling"
        width       = 100
      }
    }
    type = "floor"
  }

}




data "dnacenter_site" "example1" {
    depends_on = [dnacenter_site.example]
  provider = dnacenter
  limit    = "5"
  name     = "Global/sanjose"
}

output "dnacenter_site_example" {
  value = data.dnacenter_site.example1.items[0].id
}
