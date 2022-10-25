ndfc = {
  url      = "https://173.36.219.24",
  platform = "nd"
}

fabric_name = "fabric-demo"

inventory = {
  101 = "leaf1",
  102 = "leaf2",
  103 = "leaf3",
  104 = "leaf4",
  201 = "spine1",
  202 = "spine2",
}

loopbacks = [
  {
    loopback_id   = 20
    switch_id     = 101
    loopback_ipv4 = "100.100.100.1"
    vrf           = "vrf_app1"
    route_tag     = 12345
  },
  {
    loopback_id   = 20
    switch_id     = 102
    loopback_ipv4 = "100.100.100.1"
    vrf           = "vrf_app1"
    route_tag     = 12345
  }
]

vpcs = [
  {
    vpc_id          = 10
    switch1_id      = 101
    switch2_id      = 102
    mode            = "active"
    bpdu_guard_flag = "true"
    mtu             = "jumbo"
    peer1_members   = ["eth1/1"]
    peer2_members   = ["eth1/1"]
  },
  {
    vpc_id          = 10
    switch1_id      = 103
    switch2_id      = 104
    mode            = "active"
    bpdu_guard_flag = "true"
    mtu             = "jumbo"
    peer1_members   = ["eth1/1"]
    peer2_members   = ["eth1/1"]
  }
]

vrfs = [
  {
    name        = "vrf_app1"
    segment_id  = 50001
    vlan_id     = 2010
    description = "application1"
    attachments = [
      {
        switch_id = 101
      },
      {
        switch_id = 102
      },
      {
        switch_id = 103
      },
      {
        switch_id = 104
      }
    ]
  }
]

networks = [
  {
    name         = "network_web"
    network_id   = 30001
    vlan_id      = 2311
    description  = "network for web tier"
    vrf_name     = "vrf_app1"
    ipv4_gateway = "10.1.1.1/24"
    attachments = [
      {
        switch_id = 101
        switch_ports = [
          "Port-channel10"
        ]
      },
      {
        switch_id = 102
        switch_ports = [
          "Port-channel10"
        ]
      },
      {
        switch_id = 103
        switch_ports = [
          "Port-channel10"
        ]
      },
      {
        switch_id = 104
        switch_ports = [
          "Port-channel10"
        ]
      }
    ]
  },
  {
    name         = "network_app"
    network_id   = 30002
    vlan_id      = 2312
    description  = "network for app tier"
    vrf_name     = "vrf_app1"
    ipv4_gateway = "10.1.2.1/24"
    attachments = [
      {
        switch_id = 101
        switch_ports = [
          "Port-channel10"
        ]
      },
      {
        switch_id = 102
        switch_ports = [
          "Port-channel10"
        ]
      },
      {
        switch_id = 103
        switch_ports = [
          "Port-channel10"
        ]
      },
      {
        switch_id = 104
        switch_ports = [
          "Port-channel10"
        ]
      }
    ]
  },
  {
    name         = "network_db"
    network_id   = 30003
    vlan_id      = 2313
    description  = "network for db tier"
    vrf_name     = "vrf_app1"
    ipv4_gateway = "10.1.3.1/24"
    attachments = [
      {
        switch_id = 101
        switch_ports = [
          "Port-channel10"
        ]
      },
      {
        switch_id = 102
        switch_ports = [
          "Port-channel10"
        ]
      },
      {
        switch_id = 103
        switch_ports = [
          "Port-channel10"
        ]
      },
      {
        switch_id = 104
        switch_ports = [
          "Port-channel10"
        ]
      }
    ]
  }
]
