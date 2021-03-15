# 模拟训练服务端

## Dependence

- libc

- libc++6

## Build & Generate

Compile source code and generate executable file and DEB package.

```shell
$ sudo chmod +x build.sh
$ ./build.sh && ls build
```
## Install & Uninstall

Install DEB package.

```shell
$ sudo dpkg -i build/dmfw_sim_service-*.deb
```

Uninstall DEB package.

```shell
$ sudo dpkg -r dmfw_sim_service
```

## Usage

Start service.

```shell
$ sudo systemctl start dmfw_sim_service
```

View status of service.

```shell
$ sudo systemctl status dmfw_sim_service
● dmfw_sim_service.service - DMFW SIM SERVICE
   Loaded: loaded (/etc/systemd/system/dmfw_sim_service.service; enabled; vendor preset: enabled)
   Active: active (running) since 二 2021-02-02 20:25:57 CST; 11s ago
 Main PID: 43296 (dmfw_sim_servic)
   CGroup: /system.slice/dmfw_sim_service.service
           └─43296 /opt/dmfw_sim_service/dmfw_sim_service

2月 02 20:25:57 greatwall-GW-001M1A-FTF systemd[1]: Started DMFW SIM SERVICE.
```

View log of service.

```shell
$ sudo tail -f /opt/dmfw_sim_service/log/dmfw_sim_service_log.txt
```

Stop service.

```shell
$ sudo systemctl stop dmfw_sim_service
```

Restart service.

```shell
$ sudo systemctl restart dmfw_sim_service
```