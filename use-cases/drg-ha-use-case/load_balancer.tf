# ------ Create OCI Load Balancer on Web Spoke VCN
resource "oci_load_balancer_load_balancer" "WebLB" {
  count          = local.use_existing_network ? 0 : 1
  shape          = "100Mbps"
  compartment_id = var.compute_compartment_ocid
  subnet_ids = [
    "${oci_core_subnet.web_lb-subnet[count.index].id}"
  ]
  display_name = "WebLB"
  is_private   = false
}

# ------ Create Backend Set to Load Balancer Created Above (End User should install app on HTTP port on Web Spoke VCN VMs)
resource "oci_load_balancer_backend_set" "lb-web-backend" {
  count            = local.use_existing_network ? 0 : 1
  name             = "lb-web-backend"
  load_balancer_id = oci_load_balancer_load_balancer.WebLB[count.index].id
  policy           = "ROUND_ROBIN"
  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

# ------ Create Load Balancer Listener
resource "oci_load_balancer_listener" "lb-web-listener" {
  count                    = local.use_existing_network ? 0 : 1
  load_balancer_id         = oci_load_balancer_load_balancer.WebLB[count.index].id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backend_set.lb-web-backend[count.index].name
  port                     = 80
  protocol                 = "HTTP"
  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

# ------ Add a new Backend Set to Load Balancer
resource "oci_load_balancer_backend" "lb_backends_1" {
  count            = local.use_existing_network ? 0 : 1
  backendset_name  = oci_load_balancer_backend_set.lb-web-backend[count.index].name
  ip_address       = oci_core_instance.web-vms.0.private_ip
  load_balancer_id = oci_load_balancer_load_balancer.WebLB[count.index].id
  port             = var.backend_port
}

# ------ Add a new Backend Set to Load Balancer
resource "oci_load_balancer_backend" "lb_backends_2" {
  count            = local.use_existing_network ? 0 : 1
  backendset_name  = oci_load_balancer_backend_set.lb-web-backend[count.index].name
  ip_address       = oci_core_instance.web-vms.1.private_ip
  load_balancer_id = oci_load_balancer_load_balancer.WebLB[count.index].id
  port             = var.backend_port

}

# ------ Network Load Balancer Check Point CloudGuards Frontend Interfaces
resource "oci_network_load_balancer_network_load_balancer" "external_nlb" {
  compartment_id = var.compute_compartment_ocid

  subnet_id = local.use_existing_network ? var.north_hub_nlb_subnet_id : oci_core_subnet.north_hub_nlb_subnet[0].id

  is_preserve_source_destination = true
  display_name                   = "CheckPointExternalPublicNLB"
  is_private                     = false
}


resource "oci_network_load_balancer_backend_set" "external-lb-backend" {
  name                     = "external-lb-backend"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.external_nlb.id
  policy                   = "FIVE_TUPLE"
  health_checker {
    port        = "443"
    protocol    = "HTTPS"
    return_code = 200
    url_path    = "/"
  }
}

resource "oci_network_load_balancer_listener" "external-lb-listener" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.external_nlb.id
  name                     = "firewall-frontend"
  default_backend_set_name = oci_network_load_balancer_backend_set.external-lb-backend.name
  port                     = "0"
  protocol                 = "ANY"
}

resource "oci_network_load_balancer_backend" "external-public-lb-ends01" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.external_nlb.id
  backend_set_name         = oci_network_load_balancer_backend_set.external-lb-backend.name
  port                     = "0"
  target_id = data.oci_core_private_ips.frontend_subnet_public_ips.private_ips[0].id
}

resource "oci_network_load_balancer_backend" "external-public-lb-ends02" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.external_nlb.id
  backend_set_name         = oci_network_load_balancer_backend_set.external-lb-backend.name
  port                     = "0"
  target_id = data.oci_core_private_ips.frontend_subnet_public_ips.private_ips[1].id
}