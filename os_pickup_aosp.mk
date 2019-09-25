# This file guards most of hardware/qcom/* from
# being used on devices which use hardware/qcom-caf/*

# CAF devices still want AOSP bootctrl and keymaster HALs.
CAF_DIRS := bootctrl keymaster
LOCAL_PATH := $(call my-dir)

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
# convert CAF_DIRS to something we can give to filter
filter_CAF_DIRS := $(foreach dir,$(CAF_DIRS),%/$(dir)/Android.mk)
include $(filter,$(filter_CAF_DIRS),$(call first-makefiles-under,$(LOCAL_PATH)))
else
include $(call first-makefiles-under,$(LOCAL_PATH))
endif
