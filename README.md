# DHT11 for CHIP

This repo contains the collated and modified source code for one stop
dht11 support for C.H.I.P:

* dht11 kernel module modified to set 24 MHz PIO Interrupt Clock Select
  automatically.
* Device tree overlay autoload `systemd` oneshot service.
* Device tree overlays for 2 sensors. One connected to `PWM0` (`dht11@1`)
  and the other to `AP-EINT3` (`dht11@0`).
* Test script `probe-dht11` in `/usr/bin`

## Installing

Check the `deb` packages under Releases for the easiest install process.

```
dpkg -i dht11-chip-1.0-1.deb
systemctl enable autoload-dtbo
systemctl start autoload-dtbo
```

Corresponding `iio` device should now be available. Once the DHT11 has
been connected the connection can be tested by running the provided test
script.

```
> probe-dth11
[2017-08-18T20:44:01+0300 - dht11@0]: T=24.0C RH=34.0%
[2017-08-18T20:44:03+0300 - dht11@0]: T=24.0C RH=34.0%
[2017-08-18T20:44:05+0300 - dht11@0]: T=24.0C RH=34.0%
```

Only `AP-EINT3` is initially configured with device tree overlays. Move
`*.dtbo` files from `/opt/autoload-dtbo/disabled` `/opt/autoload-dtbo/enabled`
or vice versa to change this configuration. Other device tree overlays can also
be loaded using the same service.

## Included works

This repo collates files from multiple sources. However, all of the
collated code happens to be licensed under GPLv2+.

## Building

### Tools & dependencies

#### The kernel

CHIP-linux kernel of the `4.4.13-ntc-mlc` branch is needed for building
components. Grab the tip of `debian/4.4.13-ntc-mlc` branch as a shallow
copy and prepare it for modules. Note the `LOCALVERSION` parameter that
is required to later build compatible kernel modules.

```
git clone --single-branch --branch debian/4.4.13-ntc-mlc --depth 1 https://github.com/NextThingCo/CHIP-linux.git
cd CHIP-linux
make LOCALVERSION= modules_prepare
```

#### Device tree compiler

Debian ships `dtc 1.4.0` for the next decade or so. Get and compile `1.4.4`
from dgibson's repo. Alternative solution would be to grab the sources
from Linux git repo, but Mr. Gibson seems to be a maintainer for `dtc`
making the difference neglible.

```
apt-get install bison flex
git clone --single-branch --branch v1.4.4 --depth 1 https://github.com/dgibson/dtc.git
cd dtc
make NO_PYTHON=1
cp dtc /usr/local/bin/
```

`make install` did not seem to work as intended for `v1.4.4` tag.
However, you can always fall back to the good old `cp`.

### Building

Build the kernel module and `dts` files by running `make`. The build script
expects to find CHIP-linux at path `~/CHIP-linux`. If this is not the case
you'll have to use env parameters to guide `make`.

```
make ChipLinux=[path to CHIP-linux]
```

### Install/uninstall local build

Provided Makefiles should make installing and uninstalling as simple as running `make install`
and `make uninstall`.

### Packaging

Everything is packaged into a deb package by running `make all package`. The
will be placed in `package-workdir/dht11-chip-[version]-[pkg revision].deb`.
The resulting package does not comply with any sensible packaging guidelines.
However, it works quite well to deliver the required files to a CHIP.
