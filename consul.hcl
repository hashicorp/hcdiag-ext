host {
  selects = [""]
}

product "consul" {
  selects = [
    "ps -u C consul", "ps u -C nomad", "ps u -C vault",
    "consul version",
    "consul validate /etc/consul.d/",
    "consul operator autopilot get-config",
    "consul keyring -list",
    "dpkg-query -W consul-enterprise",
    "ls -ldF /opt/consul",
    "consul license get"
  ]

  # check which HashiCorp products are installed
  # and if they are running as dedicated user
  command {
    run = "ps -u C consul"
    format = "string"
  }
  command {
    run = "ps -u C nomad"
    format = "string"
  }
  command {
    run = "ps -u C vault"
    format = "string"
  }

  # check consul version is recent
  command {
    run = "consul version"
    format = "string"
  }
  
  # check configuration is valid
  command {
    run = "consul validate /etc/consul.d/"
    format = "string"
  }

  # get autopilot configuration for review
  command {
    run = "consul operator autopilot get-config"
    format = "string"
  }

  # check gossip is encrypted
  command {
    run = "consul keyring -list"
    format = "string"
  }

  # check consul is installed via package not binary
  command {
    run = "dpkg-query -W consul-enterprise"
    format = "string"
  }

  # check ownership of /opt/consul
  command {
    run = "ls -ldF /opt/consul"
    format = "string"
  }

  # check consul license
  command {
    run = "consul license get"
    format = "string"
  }

}
