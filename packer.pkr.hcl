packer {
  required_plugins {
    parallels = {
      version = "~> 1"
      source  = "github.com/hashicorp/parallels"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
  }
}

source "parallels-iso" "ubuntu2204" {
  boot_wait              = "1s"
  cpus                   = 1
  disk_size              = "40960"
  guest_os_type          = "ubuntu"
  http_directory         = "config"
  iso_checksum           = "file:https://old-releases.ubuntu.com/releases/22.04/SHA256SUMS"
  iso_url                = "https://old-releases.ubuntu.com/releases/22.04/ubuntu-22.04-live-server-arm64.iso"
  memory                 = 2048
  parallels_tools_flavor = "lin"
  shutdown_command       = "echo vagrant | sudo -S shutdown -P now"
  ssh_timeout            = "15m"
  ssh_username           = "vagrant"
  ssh_password           = "vagrant"
  vm_name                = "ubuntu-22.04"

  boot_command = [
    "<esc><wait>",
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]

  prlctl = [
    [
      "set",
      "ubuntu-22.04",
      "--rosetta-linux",
      "on"
    ]
  ]
}

build {
  sources = ["source.parallels-iso.ubuntu2204"]

  provisioner "file" {
    source      = "scripts/setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "shell" {
    inline = [
      "cloud-init status --long --wait",
      "chmod +x /tmp/setup.sh",
      "sudo /tmp/setup.sh enable",
      "rm -f /tmp/setup.sh",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get auto-remove -y",
      "mkdir -p /home/vagrant/.ssh",
      "curl -fL 'https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub' -o /home/vagrant/.ssh/authorized_keys",
      "chmod 0700 /home/vagrant/.ssh",
      "chmod 0600 /home/vagrant/.ssh/authorized_keys",
    ]
  }

  post-processor "vagrant" {
    output = "builds/ubuntu-22.04-{{.Provider}}.box"
  }
}
