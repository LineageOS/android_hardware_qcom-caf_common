#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

QCOM_NON_5G_PLATFORMS := \
    atoll \
    bengal \
    msm8937 \
    msm8953 \
    msm8996 \
    msm8998 \
    msmnile \ # Some devices have Snapdragon X50 external modem, which supports 5G (Samsung Galaxy S10 5G, A90 5G, Xiaomi Mi 9 Pro 5G, OnePlus 7 Pro 5G)
    sdm660 \
    sdm710 \
    sdm845 \
    sm6150 \
    trinket

QCOM_NON_WIFI_6GHZ_PLATFORMS := \
    atoll \
    bengal \
    holi \
    kona \
    msm8937 \
    msm8953 \
    msm8996 \
    msm8998 \
    msmnile \
    lito \
    sdm660 \
    sdm710 \
    sm6150 \
    trinket

QCOM_WIFI_MULTISTA_ADVANCED_PLATFORMS := \
    sun \
    canoe

QCOM_WIFI_MULTISTA_PLATFORMS := \
    taro \
    kalama \
    pineapple \
    volcano \
    $(QCOM_WIFI_MULTISTA_ADVANCED_PLATFORMS)

QCOM_WIFI_BRIDGED_SOFT_AP_PLATFROMS := \
    $(QCOM_WIFI_MULTISTA_PLATFORMS) \
    crow

PRODUCT_PACKAGES += \
    QssiFrameworksOverlay \
    QssiWifiOverlay

ifeq (,$(filter $(TARGET_BOARD_PLATFORM),$(QCOM_NON_WIFI_6GHZ_PLATFORMS)))
PRODUCT_PACKAGES += \
    QssiWifi6gOverlay

ifeq (,$(filter $(TARGET_BOARD_PLATFORM),$(QCOM_WIFI_BRIDGED_SOFT_AP_PLATFROMS)))
PRODUCT_PACKAGES += \
    QssiWifiBridgedOverlay
endif

ifeq (,$(filter	$(TARGET_BOARD_PLATFORM),$(QCOM_WIFI_MULTISTA_PLATFORMS)))
PRODUCT_PACKAGES += \
    QssiWifiMultiStaOverlay
ifeq (,$(filter $(TARGET_BOARD_PLATFORM),$(QCOM_WIFI_MULTISTA_ADVANCED_PLATFORMS)))
PRODUCT_PACKAGES += \
    QssiWifiMultiStaAdvancedOverlay
endif
endif
endif

ifneq ($(filter true,$(PRODUCT_IS_AUTOMOTIVE) $(PRODUCT_IS_ATV)),true)
PRODUCT_PACKAGES += \
    QssiFrameworksNoCarAtvOverlay
endif

ifeq ($(ENABLE_VENDOR_RIL_SERVICE), true)
PRODUCT_PACKAGES += \
    QssiFrameworksTelephonyOverlay \
    QssiTelephonyOverlay

ifeq ($(TARGET_FORCES_5G_SUPPORT),true) # Needed for some msmnile devices with Snapdragon X50 external modem.
    PRODUCT_PACKAGES += \
        QssiFrameworksTelephony5gOverlay
else ifeq (,$(filter $(TARGET_BOARD_PLATFORM),$(QCOM_NON_5G_PLATFORMS)))
    PRODUCT_PACKAGES += \
        QssiFrameworksTelephony5gOverlay
endif

ifneq ($(TARGET_HAS_NO_IMS), true)
PRODUCT_PACKAGES += \
    QssiFrameworksTelephonyImsOverlay \
    QssiTelephonyImsOverlay
endif
endif

PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

