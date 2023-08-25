# Parallels Ubuntu x86_64 Emulation

> [!IMPORTANT]  
> Requires Parallels 19+ pro or business. For more info see the [parallels documentation](https://kb.parallels.com/en/129871).

Source for creating a Vagrant box for use with parallels that supports x86_64 packages via Rosetta 2.

## Usage

You can use the box directly from Vagrant Cloud: https://app.vagrantup.com/batinicaz/boxes/parallels-ubuntu-x86_64-emulation

You will need to make sure that you enable rosetta support on the VM. You can do this using the customise function: `parallels.customize ["set", :id, "--rosetta-linux", "on"]`.

Here is a complete example:

```ruby
Vagrant.configure("2") do |config|
    config.ssh.insert_key = true
    config.vm.box = "batinicaz/parallels-ubuntu-x86_64-emulation"
    config.vm.define "ubuntu-x86_64-emulated-vm"
    config.vm.hostname = "ubuntu"

    config.vm.provider "parallels" do |prl|
        prl.name = "Ubuntu x86_64 Emulated"
        prl.check_guest_tools = false
        prl.memory = 2048
        prl.cpus = 2
    end
end
```

## Limitations

As noted in the [Parallels documentation](https://kb.parallels.com/en/129871#section5):

> Due to the way Rosetta translation functions, while it possesses impressive emulation capabilities, it's not always as simple as running any x86-64-only package on Linux virtual machines and having them work like they would on a native Intel system.
>
> **Installing x86-64 Packages**
>
> In terms of installing packages, for instance, Snap Packages are not supported in this scenario due to them containing all their dependencies in the package, and hence not being able to make use of the translation as it strictly runs off x86-64 base, while the virtual machine remains an Arm-based Linux. There is no possibility of mitigating this at the present time.
>
> Additionally, as the system itself remains an Arm-based Linux, certain packages might have dependencies that may or may not allow compiling them through Rosetta to run on an Arm system. This particular scenario can sometimes be mitigated by using an additional command before the installation.

## Build Details

The boot command will stop the Ubuntu installer from proceeding to the install wizard. 

It then launches GRUB and enters the appropriately escaped boot command to connect to the http server packer runs to serve the [user-data](./config/user-data) and auto install Ubuntu 22.04. The automatic install is using the [autoinstall](https://ubuntu.com/server/docs/install/autoinstall) functionality Ubuntu introduced in 20.04 as an alternative to the standard debian preseeding approach.

As part of the install all packages are upgraded and the user/password is set to `vagrant`/`vagrant`. Passwordless sudo is also configured.

Post install AMD64 support is enabled as per the [Parallels documentation](https://kb.parallels.com/en/129871#section3).
