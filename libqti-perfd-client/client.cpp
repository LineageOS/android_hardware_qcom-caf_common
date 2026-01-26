/*
 * Copyright (C) 2021-2024 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define LOG_TAG "libqti-perfd-client"

#include <aidl/android/hardware/power/IPower.h>
#include <aidl/android/hardware/power/Mode.h>

#include <android/binder_auto_utils.h>
#include <android/binder_manager.h>
#include <log/log.h>

#include <mutex>
#include <unordered_map>

using aidl::android::hardware::power::Boost;
using aidl::android::hardware::power::IPower;
using aidl::android::hardware::power::Mode;

namespace {

static std::shared_ptr<IPower> getPowerHal() {
    static std::mutex gMutex;
    static std::shared_ptr<IPower> gPowerHal;

    std::lock_guard<std::mutex> _l(gMutex);
    if (gPowerHal) {
        return gPowerHal;
    }

    const std::string instance = std::string(IPower::descriptor) + "/default";

    ndk::SpAIBinder binder(AServiceManager_checkService(instance.c_str()));
    if (!binder.get()) {
        ALOGE("Power HAL AIDL service \"%s\" not found", instance.c_str());
        return nullptr;
    }

    gPowerHal = IPower::fromBinder(binder);
    if (!gPowerHal) {
        ALOGE("Failed to get IPower interface from binder");
        return nullptr;
    }

    ALOGI("Connected to Power HAL AIDL service \"%s\"", instance.c_str());
    return gPowerHal;
}

constexpr int HINT_CAMERA_LAUNCH = 0x1337;
constexpr int HINT_CAMERA_STOP = 0x1338;

std::mutex gCameraModeMutex;
Mode gActiveCameraMode;
bool gHasActiveCameraMode = false;

static const std::unordered_map<int, Mode> kHintIdToMode = {
        {0x00001330, Mode::CAMERA_STREAMING_LOW},
        {0x00001331, Mode::CAMERA_STREAMING_MID},
        {0x00001332, Mode::CAMERA_STREAMING_HIGH},
        {0x00001333, Mode::CAMERA_STREAMING_HIGH},
};

void stopActiveCameraModeLocked(std::shared_ptr<IPower> powerHal) {
    if (!gHasActiveCameraMode) return;

    ndk::ScopedAStatus status = powerHal->setMode(gActiveCameraMode, false);
    if (!status.isOk()) {
        ALOGE("%s: failed to disable mode: %d", __func__, gActiveCameraMode);
    }
    gHasActiveCameraMode = false;
}

}  // anonymous namespace

extern "C" void perf_event(int arg1, char* arg2, int arg3, int* arg4) {
    ALOGI("%s: arg1: %d, arg2: %s, arg3: %d", __func__, arg1, arg2, arg3);
}

extern "C" int perf_get_feedback(int arg1, char* arg2) {
    ALOGI("%s: arg1: %d, arg2: %s,", __func__, arg1, arg2);
    return 233;
}

extern "C" int perf_get_feedback_extn(int arg1, char* arg2, unsigned int arg3, char* arg4) {
    ALOGI("%s: arg1: %d, arg2: %s, arg3: %d, arg4: %s", __func__, arg1, arg2, arg3, arg4);
    return 233;
}

extern "C" void perf_hint(int arg1, char* arg2, int arg3, int arg4) {
    ALOGI("%s: arg1: %d, arg2: %s, arg3: %d, arg4: %d", __func__, arg1, arg2, arg3, arg4);
}

extern "C" int perf_hint_renew(int arg1, int hint_id, const char* arg3, int duration, int arg5,
                               int arg6, int arg7[]) {
    ALOGI("%s: arg1: %d, hint_id: 0x%x, arg3: %s, duration: %d, arg5: %d, arg6: %d", __func__, arg1,
          hint_id, arg3, duration, arg5, arg6);

    auto powerHal = getPowerHal();
    if (!powerHal) {
        ALOGE("%s: Power HAL not available", __func__);
        return 233;
    }

    if (hint_id == HINT_CAMERA_LAUNCH) {
        ndk::ScopedAStatus status = powerHal->setBoost(Boost::CAMERA_LAUNCH, 0);
        return status.isOk() ? 233 : -1;
    }

    if (hint_id == HINT_CAMERA_STOP) {
        std::lock_guard<std::mutex> lock(gCameraModeMutex);
        stopActiveCameraModeLocked(powerHal);
        return 233;
    }

    Mode newMode;
    auto it = kHintIdToMode.find(hint_id);
    if (it == kHintIdToMode.end()) {
        ALOGI("%s: no Mode mapping for hint_id=0x%x, ignoring hint", __func__, hint_id);
        return 233;
    }
    Mode mode = it->second;

    {
        std::lock_guard<std::mutex> lock(gCameraModeMutex);
        if (gHasActiveCameraMode && gActiveCameraMode == mode) {
            return 233;
        }

        stopActiveCameraModeLocked(powerHal);

        ndk::ScopedAStatus status = powerHal->setMode(mode, true);
        if (!status.isOk()) {
            return -1;
        }
        ALOGI("%s: setMode(%d, true) succeeded for hint_id=0x%x", __func__, static_cast<int>(mode),
              hint_id);
        gActiveCameraMode = mode;
        gHasActiveCameraMode = true;
    }

    return 233;
}

extern "C" int perf_lock_acq(int handle, int duration, int list[], int numArgs) {
    ALOGI("%s: handle: %d, duration: %d, numArgs: %d", __func__, handle, duration, numArgs);
    for (int i = 0; i < numArgs; i++) {
        ALOGI("%s: list[%d]: 0x%x", __func__, i, list[i]);
    }
    return handle ?: 233;
}

extern "C" void perf_lock_cmd(int arg1) {
    ALOGI("%s: arg1: %d", __func__, arg1);
}

extern "C" int perf_lock_rel(int handle) {
    ALOGI("%s: handle: %d", __func__, handle);
    return handle ?: 233;
}

extern "C" int perf_lock_use_profile(int handle, int profile) {
    ALOGI("%s: handle: %d, profile: %d", __func__, handle, profile);
    return handle ?: 233;
}

extern "C" void perf_wait_get_prop(char* arg1, char* arg2) {
    ALOGI("%s: handle: %s, profile: %s", __func__, arg1, arg2);
}
