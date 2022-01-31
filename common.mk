#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

QTI_COMMON_PATH := $(LOCAL_PATH)

# Components
ifeq ($(PRODUCT_QTI_COMPONENTS), all)
PRODUCT_QTI_COMPONENTS := \
    init
endif

# Initialization
PRODUCT_PACKAGES += \
    init.class_main.sh \
    init.mdm.sh \
    init.qcom.early_boot.sh \
    init.qcom.post_boot.sh \
    init.qcom.rc \
    init.qcom.sh \
    ueventd.qcom.rc

ifneq (,$(filter init, $(PRODUCT_QTI_COMPONENTS)))
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)/init
endif
