#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# WiFi
ifneq (,$(filter init, $(PRODUCT_QTI_COMPONENTS)))
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
endif
