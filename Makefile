#   dht11-chip
#   Copyright (C) 2017  Vilppu Vuorinen <vilppu.jotain@gmail.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

SHELL := /bin/bash

PROJECT := dht11-chip
VERSION_MAJOR := 1
VERSION_MINOR := 0
PACKAGE_REV := 1
PACKAGE_TMP = package-workdir
PACKAGE_DIR = $(PACKAGE_TMP)/$(PROJECT)-$(VERSION_MAJOR).$(VERSION_MINOR)-$(PACKAGE_REV)

ChipLinux ?= ~/CHIP-linux

.PHONY: all
all: dht11-kernel-module dtb-overlay

.PHONY: dht11-kernel-module
dht11-kernel-module:
	pushd dht11 \
		&& make ChipLinux=$(ChipLinux) \
		; popd

.PHONY: dtb-overlay
dtb-overlay:
	pushd dtb-overlay \
		&& make ChipLinux=$(ChipLinux) \
		; popd

.PHONY: clean
clean:
	-pushd dht11 \
		&& make clean ChipLinux=$(ChipLinux) \
		; popd
	-pushd dtb-overlay \
		&& make clean ChipLinux=$(ChipLinux) \
		; popd
	-rm -rf $(PACKAGE_TMP) &> /dev/null

AUTOLOAD_DTBO_DIR = $(DESTDIR)/opt/autoload-dtbo
ENABLED_DTBO = $(AUTOLOAD_DTBO_DIR)/enabled
DISABLED_DTBO = $(AUTOLOAD_DTBO_DIR)/disabled
KERNEL_MODULE_DIR = $(DESTDIR)/lib/modules/4.4.13-ntc-mlc/kernel/drivers/iio/humidity
SYSTEMD_SERVICE_DIR = $(DESTDIR)/lib/systemd/system
BIN_DIR = $(DESTDIR)/usr/bin

.PHONY: install
install:
	mkdir -p $(ENABLED_DTBO)
	mkdir -p $(DISABLED_DTBO)
	mkdir -p $(KERNEL_MODULE_DIR)
	mkdir -p $(SYSTEMD_SERVICE_DIR)
	mkdir -p $(BIN_DIR)
	cp -f dtb-overlay/dht11-ap-eint3.dtbo $(ENABLED_DTBO)/
	cp -f dtb-overlay/dht11-pwm0.dtbo $(DISABLED_DTBO)/
	cp -f dtb-overlay/pwm0.dtbo $(DISABLED_DTBO)/
	cp -f systemd/autoload-dtbo.sh $(AUTOLOAD_DTBO_DIR)/
	cp -f systemd/autoload-dtbo.service $(SYSTEMD_SERVICE_DIR)/
	cp -f dht11/dht11.ko $(KERNEL_MODULE_DIR)/
	cp -f probe-dht11 $(BIN_DIR)/

.PHONY: uninstall
uninstall:
	-rmmod dht11
	-systemctl disable autoload-dtbo.service
	-rm -rf $(DESTDIR)/opt/autoload-dtbo
	-rm -rf $(DESTDIR)/lib/modules/4.4.13-ntc-mlc/kernel/drivers/iio/humidity
	-rm $(DESTDIR)/lib/systemd/system/autoload-dtbo.service

.PHONY: package
package:
	mkdir -p $(PACKAGE_DIR)/
	make install DESTDIR=$(PACKAGE_DIR)
	cp -rf DEBIAN $(PACKAGE_DIR)/
	dpkg-deb --build $(PACKAGE_DIR)


