/*
 * Copyright (C) 2022 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "nqnfcinfo"

#include <errno.h>

#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>

#include <android-base/logging.h>
#include <android-base/properties.h>
#include <android-base/unique_fd.h>

using ::android::base::SetProperty;
using ::android::base::unique_fd;

#include <linux/nfc/nfcinfo.h>

#define NQ_NCI_PATH "/dev/nq-nci"

int main() {
    // Set up our data types
    unique_fd nq_fd(open(NQ_NCI_PATH, O_RDONLY));
    union nqx_uinfo info = {};

    // Make sure we could get the fd
    if (nq_fd < 0) {
       LOG(ERROR) << "Could not open " << NQ_NCI_PATH << " ret: " << nq_fd << " errno: " << errno;
       return nq_fd;
    }

    // NXP's kernel driver returns a struct that is union'ed with an integer
    // as the return value of the IOCTL call here. Presumably this is to avoid
    // dealing with copying memory to/from userspace, but it's a little silly
    // Since this is an unsigned type, I don't know how to check for errors...
    info.i = ioctl(nq_fd, NFCC_GET_INFO, 0);

    // Set properties based on IOCTL return
    std::stringstream chipid;
    chipid << "0x" << std::setfill('0') << std::setw(2) << std::hex << info.info.chip_type;
    SetProperty("vendor.qti.nfc.chipid", chipid.str());
    std::stringstream fwver;
    fwver << std::setfill('0') << std::setw(2) << std::hex << info.info.rom_version;
    fwver << "." << std::setfill('0') << std::setw(2) << std::hex << info.info.fw_major;
    fwver << "." << std::setfill('0') << std::setw(2) << std::hex << info.info.fw_minor;
    SetProperty("vendor.qti.nfc.fwver", fwver.str());

    return 0;
}
