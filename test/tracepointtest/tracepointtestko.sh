#!/bin/sh
################################################################################
#
# Copyright (C) 2022 Huawei Device Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################
# File: tracepointtestko.sh
#
# Description: tracepoint ko test
#
# Authors:     yang ming di
#
# History:     August 4 2022 - tracepoint ko test
#
################################################################################

CURRENT_DIR=$(pwd)
KO_DIR=$CURRENT_DIR/kofile

insmod_ko() {
  for dir in $(ls $KO_DIR); do
    if [[ "$dir" != "tracepoint_test.ko" ]]; then
      insmod $KO_DIR/$dir
      echo "$KO_DIR/$dir is loaded"
    fi
  done

  insmod $KO_DIR/tracepoint_test.ko

  arr=(vendor_do_mmap vendor_do_mprotect_pkey vendor_aml_emmc_partition vendor_fake_boot_partition)
  for i in ${arr[@]}; do
    dmesg | grep $i >/dev/null
    if [ $? -eq 0 ]; then
      echo "tracepoint $i succeed"
    else
      echo "tracepoint $i failed"
    fi
  done
}

rmmod_ko() {
  for dir in $(ls $KO_DIR); do
      rmmod $KO_DIR/$dir
      echo "$KO_DIR/$dir is removed"
  done
}

main() {
  if [[ $1 == "rmmod_ko" ]]; then
    rmmod_ko
  else
    insmod_ko
  fi
}

main $1
