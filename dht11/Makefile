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

ChipLinux ?= "~/CHIP-linux"

obj-m += dht11.o

all: dht11.ko


dht11.ko: dht11.c
	make -C $(ChipLinux) M=$(PWD) modules

install: dht11.ko
	mkdir -p /lib/modules/4.4.13-ntc-mlc/kernel/drivers/iio/humidity
	chmod +x dht11.ko
	cp -f dht11.ko /lib/modules/4.4.13-ntc-mlc/kernel/drivers/iio/humidity
	depmod

clean:
	-rm dht11.o
	-make -C $(ChipLinux) M=$(PWD) clean
