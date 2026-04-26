#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

QCOM_NON_6GHZ_PLATFORMS := \
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

$(call soong_config_set_bool,qssi,atv_or_car,$(filter true,$(PRODUCT_IS_AUTOMOTIVE) $(PRODUCT_IS_ATV)))

ifeq ($(filter $(TARGET_BOARD_PLATFORM),$(QCOM_WIFI_NON_6GHZ_PLATFORMS)),)
$(call soong_config_set,qssi,wifi,6g)
ifneq ($(filter $(TARGET_BOARD_PLATFORM),$(QCOM_WIFI_MULTISTA_PLATFORMS)),)
$(call soong_config_set,qssi,wifi,multista)
ifneq ($(filter $(TARGET_BOARD_PLATFORM),$(QCOM_WIFI_MULTISTA_ADVANCED_PLATFORMS)),)
$(call soong_config_set,qssi,wifi,multista_advanced)
endif
endif
endif

ifneq ($(ENABLE_VENDOR_RIL_SERVICE),true)
$(call soong_config_set,qssi,telephony,none)
else ifneq ($(filter $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY) $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(call soong_config_set,qssi,telephony,5g)
else
$(call soong_config_set,qssi,telephony,lte)
endif
$(call soong_config_set_bool,qssi,supports_ims,$(filter-out true,$(TARGET_HAS_NO_IMS)))
$(call soong_config_set_bool,qssi,supports_wfd,$(filter-out true,$(TARGET_HAS_NO_QCOM_WFD)))

PRODUCT_PACKAGES += \
   QssiCommonOverlay

PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

