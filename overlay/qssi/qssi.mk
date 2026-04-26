#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

$(call soong_config_set_bool,qssi,atv_or_car,$(filter true,$(PRODUCT_IS_AUTOMOTIVE) $(PRODUCT_IS_ATV)))
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

