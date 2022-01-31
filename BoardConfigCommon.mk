#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# SELinux
ifneq ($(BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE),)
include device/qcom/sepolicy_vndr/SEPolicy.mk
else
include device/qcom/sepolicy/SEPolicy.mk
endif

# VINTF
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    $(QTI_COMMON_PATH)/vendor_framework_compatibility_matrix.xml

# WiFi
ifneq (,$(filter init, $(PRODUCT_QTI_COMPONENTS)))
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
endif
