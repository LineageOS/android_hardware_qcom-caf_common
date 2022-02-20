# This file guards most of hardware/qcom/* from
# being used on devices which use hardware/qcom-caf/*

LOCAL_PATH := $(call my-dir)

# Legacy CAF devices still want AOSP keymaster HAL.
ifeq ($(call is-board-platform-in-list, $(QCOM_BOARD_PLATFORMS)),true)
include $(LOCAL_PATH)/keymaster/Android.mk
else
include $(call first-makefiles-under,$(LOCAL_PATH))
endif
