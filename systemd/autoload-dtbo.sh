#!/bin/bash
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

echo "Loading decive tree overlays... [DTBO_AUTOLOAD_PATH=${DTBO_AUTOLOAD_PATH}] => [DTBO_CONFIG_PATH=${DTBO_CONFIG_PATH}]"
for f in ${DTBO_AUTOLOAD_PATH}/*.dtbo; do
  DTBO_BASE="$(basename ${f})"
  echo "+ ${DTBO_BASE}"
  mkdir -p "${DTBO_CONFIG_PATH}/${DTBO_BASE%.*}"
  cat "${f}" > "${DTBO_CONFIG_PATH}/${DTBO_BASE%.*}/dtbo"
done
echo "Overlays loaded"
