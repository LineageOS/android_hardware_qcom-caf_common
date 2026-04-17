#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_PACKAGES += \
    QssiFrameworksOverlay \
    QssiWifiOverlay

ifeq ($(ENABLE_VENDOR_RIL_SERVICE), true)
PRODUCT_PACKAGES += \
    QssiFrameworksTelephonyOverlay \
    QssiTelephonyOverlay

ifeq ($(TARGET_HAS_NO_IMS), true)
PRODUCT_PACKAGES += \
    QssiFrameworksTelephonyImsOverlay \
    QssiTelephonyImsOverlay
endif
endif

PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
