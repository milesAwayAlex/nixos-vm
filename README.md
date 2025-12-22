# NixOS VM Flake

This repo contains a nix flake that I use to generate qcow2 images to run UTM VMs. It's written to accept a second qcow2 image to persist user data.

## To run a VM

First build the qcow2 image with the desired configuration
```shell
nix build .#qcow
```

Once the image is ready, configure the UTM VM:
- QEMU:
    - [x] UEFI Boot
    - [x] RNG Device
    - [x] Use Hypervisor
    - [ ] everything else
- Sharing:
    - [x] Enable Clipboard Sharing
- Display:
    - Emulated Display Card: virtio-gpu-gl-pci
    - [x] GPU Acceleration Supported
    - [x] Resize display to window size automatically
    - [x] Retina Mode
- Network:
    - Network Mode: Shared Network
    - Emulated Network Card: virtio-net-pci
- VirtIO Drive:
    - Interface: VirtIO
    - [ ] Read Only? (has to be writable)
    - Name: `<your-nixos-image>.qcow2`
- VirtIO Drive:
    - Interface: VirtIO
    - Name: `<your-persistent-image>.qcow2`

Export the VM somewhere like the `vm` directory at the root of the repo, then copy the resulting qcow2 image to the vm directory
```shell
cp result/nixos.qcow2 <path-to-your-vm-directory>/Data/<your-nixos-image>.qcow2
```
Copy the persistent image to the same directory. The VM should be ready to run.

## To create a new persistent image

First, create a blank qcow2 file
```shell
qemu-img create -f qcow2 <your-persistent-image>.qcow2 100G
```

Next comes the tricky part if you're on darwin - you need to format the new disk. I used the VM image without the external home directory and the blank disk connected. Then, within the VM:
```shell
sudo mkfs.ext4 /dev/vdb
```

Now the new disk is ready to be used. Rebuild and replace the qcow2 image to have the persistent disk mounted as the home directory.

## Roadmap

- [x] Parameterize the username
- [ ] Add a linter/formatter
- [ ] Update the flake outputs to work cross-system
- [ ] Add an output to rebuild the running system
- [ ] Text-only mode and native nix VMs
- [ ] A dev VM for flakes
