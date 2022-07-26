ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS), true)
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.vendor.qti.va_aosp.support=1

ADDITIONAL_ODM_PROPERTIES += \
    ro.vendor.qti.va_odm.support=1
endif #TARGET_FWK_SUPPORTS_FULL_VALUEADDS
