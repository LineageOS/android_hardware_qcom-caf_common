ifeq ($(call my-dir),$(call project-path-for,qcom-platform-superproject))
include $(call first-makefiles-under,$(call my-dir))
endif
