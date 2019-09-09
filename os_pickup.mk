ifeq ($(call my-dir),$(call project-path-for,qcom-platform-superproject))
include $(call first-makefiles-under,$(LOCAL_PATH))
endif
