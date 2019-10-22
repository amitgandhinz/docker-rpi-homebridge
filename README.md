# docker-rpi-homebridge
Docker image for running [Homebridge](https://github.com/nfarina/homebridge) on a Raspberry Pi

## Homebridge
Here is what the author has to say about Homebridge:

> Homebridge is a lightweight NodeJS server you can run on your home network that emulates the iOS HomeKit API. It supports Plugins, which are community-contributed modules that provide a basic bridge from HomeKit to various 3rd-party APIs provided by manufacturers of "smart home" devices.

This project is just a Docker container that makes it easy to deploy Homebridge on your Raspberry Pi.

## Getting Docker on your Raspberry Pi
I recommend checking out [Hypriot](http://blog.hypriot.com/) and their [Getting Started](http://blog.hypriot.com/getting-started-with-docker-on-your-arm-device/) guide

## Configuration
There are two files that need to be provided in order for Homebridge to run.

 * `config.json`: For a quick start, you can copy `config-sample.json` and modify it to your needs. For detailed explanation of this file, check out the [documentation](https://github.com/nfarina/homebridge#installation) provided by Homebridge
 * `plugins.txt`: in order to do anything, Homebridge needs to install plugins for your accessories and platforms. You can list them here with each npm package on a new line. See `plugins-sample.txt` for an example and, again, check out the [documentation](https://github.com/nfarina/homebridge#installing-plugins) provided by Homebridge for more details.

## Docker for Linux
This image is hosted on Docker Hub tagged as [vividboarder/rpi-homebridge](https://hub.docker.com/r/vividboarder/rpi-homebridge/), so you can feel free to use the `docker-compose.yaml` and change `build: .` to `image: vividboarder/rpi-homebridge`. After that, `docker-compose up` should get you started.

Alternately, you can compile the image yourself by cloning this repo and using `docker-compose`

```
docker-compose up -d 
```

If you want a little more control, you can use any of the make targets:

```
make build  # builds a new image
make run    # builds and runs container using same parameters as compose
make shell  # builds and runs an interractive container
make tag    # tags image to be pushed to docker hub
make push   # pushes image to docker hub
```

## Docker for Windows
Create a connected VM with HyperV, mapping the vm with an IP visible on your network (External NAT on the HyperV Switch Settings).
You will likely need to create the new switch in `Hyper-V Manager` if it doesnt already exist. 
Name the new Virtual Switch `ExternalNAT` and assign it to the External Network (choosing your internet connection device (wireless/ethernet)) 



### Creating your Environment (use docker-machine v0.15+)
```
docker-machine create -d hyperv --hyperv-virtual-switch "ExternalNAT" homebridgeVM
```

A new virtual machine will be created in Hyper-V named `homebridgeVM`.  
Wait for your host to start ...

Note - if your new VM doesnt have an IP address associated to it, you may need to run the following command after checking that the ExternalNAT is setup correctly and not conflicting with DockerNAT:

```
docker-machine restart homebridgeVM
```

### Connect to your docker machine
```
docker-machine env homebridgeVM

& "C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe" env homebridgeVM | Invoke-Expression
```

### Regenerate Certs if required
If you get a warning about certificates not being valid, you may need to regenerate this as follows:
```
docker-machine regenerate-certs homebridgeVM
```

### Running your image
```
docker-compose up -d --build
```

Note - when building your container, if you get an error mounting your local volume (firewall restriction), see https://stackoverflow.com/questions/42203488/settings-to-windows-firewall-to-allow-docker-for-windows-to-share-drive/43904051#43904051

```
Set-NetConnectionProfile -interfacealias "vEthernet (ExternalNAT)" -NetworkCategory Private
```


### Watching your logs
```
docker logs -f docker-rpi-homebridge_homebridge_1
```

## Issues?
Feel free to report any issues you're having getting this to run on [Github](https://github.com/ViViDboarder/docker-rpi-homebridge/issues)
