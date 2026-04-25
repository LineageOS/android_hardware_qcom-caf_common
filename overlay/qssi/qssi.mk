#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_PACKAGES += \
    QssiFrameworksOverlay \
    QssiWifiOverlay

ifneq ($(filter true,$(PRODUCT_IS_AUTOMOTIVE) $(PRODUCT_IS_ATV)),true)
PRODUCT_PACKAGES += \
    QssiFrameworksNoCarAtvOverlay
endif

ifeq ($(ENABLE_VENDOR_RIL_SERVICE), true)
PRODUCT_PACKAGES += \
    QssiFrameworksTelephonyOverlay \
    QssiTelephonyOverlay

ifneq ($(TARGET_HAS_NO_IMS), true)
PRODUCT_PACKAGES += \
    QssiFrameworksTelephonyImsOverlay \
    QssiTelephonyImsOverlay
endif
endif

PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
