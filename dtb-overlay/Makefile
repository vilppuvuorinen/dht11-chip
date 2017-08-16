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

ChipLinux ?= ~/CHIP-linux
PreProcTmp := tmp-preproc.dts

.PHONY: all
all: dht11-pwm0.dtbo dht11-ap-eint3.dtbo pwm0.dtbo

load-dht11-pwm0: dht11-pwm0.dtbo
	mkdir -p /sys/kernel/config/device-tree/overlays/dht11
	cat dht11-pwm0.dtbo > /sys/kernel/config/device-tree/overlays/dht11/dtbo

load-dht11-ap-eint3: dht11-ap-eint3.dtbo
	mkdir -p /sys/kernel/config/device-tree/overlays/dht11
	cat dht11-ap-eint3.dtbo > /sys/kernel/config/device-tree/overlays/dht11/dtbo

dht11-pwm0.dtbo: dht11-pwm0.dts
	cpp -nostdinc -I $(ChipLinux)/include/ -undef -x assembler-with-cpp dht11-pwm0.dts > $(PreProcTmp)
	dtc -O dtb -o dht11-pwm0.dtbo -b0 -@ $(PreProcTmp)
	rm $(PreProcTmp)

dht11-ap-eint3.dtbo: dht11-ap-eint3.dts
	cpp -nostdinc -I $(ChipLinux)/include/ -undef -x assembler-with-cpp dht11-ap-eint3.dts > $(PreProcTmp)
	dtc -O dtb -o dht11-ap-eint3.dtbo -b0 -@ $(PreProcTmp)
	rm $(PreProcTmp)

pwm0.dtbo: pwm0.dts
	cpp -nostdinc -I $(ChipLinux)/include/ -undef -x assembler-with-cpp pwm0.dts > $(PreProcTmp)
	dtc -O dtb -o pwm0.dtbo -b0 -@ $(PreProcTmp)
	rm $(PreProcTmp)

.PHONY: clean
clean:
	-rm dht11-pwm0.dtbo 2>/dev/null; true
	-rm dht11-ap-eint3.dtbo 2>/dev/null; true
	-rm pwm0.dtbo 2>/dev/null; true
	-rm $(PreProcTmp) 2>/dev/null; true

