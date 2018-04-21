variable "do_token" {}
variable "aws_key" {}
variable "aws_secret" {}
variable "aws_region" {}

variable "domain_1" {}

output "ip" {
    value = "${digitalocean_droplet.web.ipv4_address}"
}

provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_droplet" "web" {
    image = "ubuntu-16-04-x64"
    name = "test-web-1"
    region = "nyc3"
    size = "s-1vcpu-1gb"
}

provider "aws" {
    access_key = "${var.aws_key}"
    secret_key = "${var.aws_secret}"
    region     = "${var.aws_region}"
}

data "aws_route53_zone" "mediocrely" {
    name = "${var.domain_1}"
    private_zone = false
}

resource "aws_route53_record" "www" {
    zone_id = "${data.aws_route53_zone.mediocrely.zone_id}"
    name = "ziggurat.${data.aws_route53_zone.mediocrely.name}"
    type = "A"
    ttl = "300"
    records = ["${digitalocean_droplet.web.ipv4_address}"]
}