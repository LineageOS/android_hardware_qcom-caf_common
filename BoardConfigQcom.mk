include hardware/qcom-caf/common/qcom_boards.mk
include hardware/qcom-caf/common/qcom_defs.mk

UM_3_18_HAL_FAMILY := msm8996
UM_4_4_HAL_FAMILY := msm8998

ifeq (,$(TARGET_ENFORCES_QSSI))
UM_3_18_HAL_FAMILY += msm8937 msm8953
UM_4_4_HAL_FAMILY += sdm660
else
UM_4_9_LEGACY_FAMILY := msm8937 msm8953
UM_4_19_LEGACY_FAMILY := sdm660
endif

UM_PLATFORMS := \
    $(UM_3_18_FAMILY) \
    $(UM_4_4_FAMILY) \
    $(UM_4_9_FAMILY) \
    $(UM_4_14_FAMILY) \
    $(UM_4_19_FAMILY) \
    $(UM_5_4_FAMILY) \
    $(UM_5_10_FAMILY) \
    $(UM_5_15_FAMILY) \
    $(UM_6_1_FAMILY) \
    $(UM_6_6_FAMILY)

LEGACY_UM_PLATFORMS := \
    $(UM_3_18_FAMILY) \
    $(UM_4_4_FAMILY) \
    $(UM_4_9_FAMILY) \
    $(UM_4_14_FAMILY) \
    $(UM_4_19_FAMILY) \
    $(UM_5_4_FAMILY)

QSSI_SUPPORTED_PLATFORMS := \
    $(UM_4_9_LEGACY_FAMILY) \
    $(UM_4_19_LEGACY_FAMILY) \
    $(UM_4_9_FAMILY) \
    $(UM_4_14_FAMILY) \
    $(UM_4_19_FAMILY) \
    $(UM_5_4_FAMILY) \
    $(UM_5_10_FAMILY) \
    $(UM_5_15_FAMILY) \
    $(UM_6_1_FAMILY) \
    $(UM_6_6_FAMILY)

BOARD_USES_ADRENO := true

# Disable thermal HAL netlink framework on UM platforms that do not support it
ifneq ($(filter $(LEGACY_UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
    $(call soong_config_set,qti_thermal,netlink,false)
endif

# Configure audio HAL features
ifeq ($(AUDIO_FEATURE_ENABLED_CIRRUS_CALIBRATION_RESISTANCE),true)
    $(call soong_config_set,qtiaudio,cirrus_calibration_resistance,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_AGM_HIDL),true)
    $(call soong_config_set,qtiaudio,feature_agm_hidl,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLE_BT_A2DP_LPI),true)
    $(call soong_config_set,qtiaudio,feature_bt_a2dp_lpi,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_DEVICE_PREPARE_SEQ),true)
    $(call soong_config_set,qtiaudio,feature_device_prepare_seq,true)
endif

ifeq ($(AUDIO_FEATURE_DISABLED_DTS_EAGLE),true)
    $(call soong_config_set,qtiaudio,feature_disabled_dts_eagle,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_DYNAMIC_SR),true)
    $(call soong_config_set,qtiaudio,feature_dynamic_sr,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_EC_REF_CAPTURE),true)
    $(call soong_config_set,qtiaudio,feature_ec_ref_capture,true)
endif

ifeq ($(AUDIO_FEATURE_ELLIPTIC_ULTRASOUND_SUPPORT),true)
    $(call soong_config_set,qtiaudio,feature_elliptic_ultrasound,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_EXT_AMPLIFIER),true)
    $(call soong_config_set,qtiaudio,feature_ext_amplifier,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT),true)
    $(call soong_config_set,qtiaudio,feature_extended_compress_format,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_GEF_SUPPORT),true)
    $(call soong_config_set,qtiaudio,feature_gef_support,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_GKI),true)
    $(call soong_config_set,qtiaudio,feature_gki,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_HAL_V7), true)
    $(call soong_config_set,qtiaudio,feature_hal_v7,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_INSTANCE_ID),true)
    $(call soong_config_set,qtiaudio,feature_instance_id,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_KEEP_ALIVE),true)
    $(call soong_config_set,qtiaudio,feature_keep_alive,true)
endif

ifeq ($(SOUND_TRIGGER_FEATURE_LPMA_ENABLED),true)
    $(call soong_config_set,qtiaudio,feature_lpma,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_LSM_HIDL),true)
    $(call soong_config_set,qtiaudio,feature_lsm_hidl,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_MCS),true)
    $(call soong_config_set,qtiaudio,feature_mcs,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_PAL_HIDL),true)
    $(call soong_config_set,qtiaudio,feature_pal_hidl,true)
endif

ifeq ($(BOARD_SUPPORTS_QSTHW_API),true)
    $(call soong_config_set,qtiaudio,feature_qsthw_api,true)
endif

ifeq ($(BOARD_SUPPORTS_SOUND_TRIGGER),true)
    $(call soong_config_set,qtiaudio,feature_sound_trigger,true)
endif

ifeq ($(BOARD_SUPPORTS_SOUND_TRIGGER_HAL),true)
    $(call soong_config_set,qtiaudio,feature_sound_trigger,true)
endif

ifeq ($(BOARD_SUPPORTS_SOUND_TRIGGER_CPU_AFFINITY_SET),true)
    $(call soong_config_set,qtiaudio,feature_sound_trigger_cpu_affinity_set,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_SVA_MULTI_STAGE),true)
    $(call soong_config_set,qtiaudio,feature_sva_multi_stage,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_TRUE_STEREO),true)
    $(call soong_config_set,qtiaudio,feature_true_stereo,true)
endif

ifneq ($(TARGET_PAL_SPKR_PROTECTION_PATH),)
    $(call soong_config_set,qtiaudio,pal_spkr_protection_path,$(TARGET_PAL_SPKR_PROTECTION_PATH))
endif

ifeq ($(AUDIO_FEATURE_ENABLED_ULTRASOUND_PROXIMITY),true)
    $(call soong_config_set,qtiaudio,ultrasound_proximity,true)
endif

# Add qtidisplay to soong config namespaces
SOONG_CONFIG_NAMESPACES += qtidisplay

# Add supported variables to qtidisplay config
SOONG_CONFIG_qtidisplay += \
    composer_version \
    drmpp \
    headless \
    llvmsa \
    gralloc4 \
    displayconfig_enabled \
    udfps \
    default \
    master_side_cp \
    shift_horizontal \
    shift_vertical \
    smmu_proxy \
    var1 \
    var2 \
    var3 \
    hwasan \
    llvmcov \
    mapper_ext \
    ubwcp_headers \
    wide_color \
    target_kernel_version \
    target_no_raw10_custom_format \
    target_uses_aligned_ycbcr_height \
    target_uses_aligned_ycrcb_height \
    target_uses_unaligned_nv21_zsl \
    target_uses_unaligned_ycrcb \
    target_uses_ycrcb_camera_preview \
    target_uses_ycrcb_venus_camera_preview

# Set default values for qtidisplay config
SOONG_CONFIG_qtidisplay_composer_version ?= v3_3
SOONG_CONFIG_qtidisplay_drmpp ?= false
SOONG_CONFIG_qtidisplay_headless ?= false
SOONG_CONFIG_qtidisplay_llvmsa ?= false
SOONG_CONFIG_qtidisplay_gralloc4 ?= false
SOONG_CONFIG_qtidisplay_displayconfig_enabled ?= false
SOONG_CONFIG_qtidisplay_udfps ?= false
SOONG_CONFIG_qtidisplay_default ?= true
SOONG_CONFIG_qtidisplay_master_side_cp ?= false
SOONG_CONFIG_qtidisplay_shift_horizontal ?= 0
SOONG_CONFIG_qtidisplay_shift_vertical ?= 0
SOONG_CONFIG_qtidisplay_smmu_proxy ?= false
SOONG_CONFIG_qtidisplay_var1 ?= false
SOONG_CONFIG_qtidisplay_var2 ?= false
SOONG_CONFIG_qtidisplay_var3 ?= false
SOONG_CONFIG_qtidisplay_hwasan ?= false
SOONG_CONFIG_qtidisplay_llvmcov ?= false
SOONG_CONFIG_qtidisplay_mapper_ext ?= true
SOONG_CONFIG_qtidisplay_ubwcp_headers ?= false
SOONG_CONFIG_qtidisplay_wide_color ?= false
SOONG_CONFIG_qtidisplay_target_kernel_version ?= 0
SOONG_CONFIG_qtidisplay_target_no_raw10_custom_format ?= false
SOONG_CONFIG_qtidisplay_target_uses_aligned_ycbcr_height ?= false
SOONG_CONFIG_qtidisplay_target_uses_aligned_ycrcb_height ?= false
SOONG_CONFIG_qtidisplay_target_uses_unaligned_nv21_zsl ?= false
SOONG_CONFIG_qtidisplay_target_uses_unaligned_ycrcb ?= false
SOONG_CONFIG_qtidisplay_target_uses_ycrcb_camera_preview ?= false
SOONG_CONFIG_qtidisplay_target_uses_ycrcb_venus_camera_preview ?= false

ifneq ($(TARGET_DISPLAY_SHIFT_HORIZONTAL),)
    SOONG_CONFIG_qtidisplay_shift_horizontal := $(TARGET_DISPLAY_SHIFT_HORIZONTAL)
endif

ifneq ($(TARGET_DISPLAY_SHIFT_VERTICAL),)
    SOONG_CONFIG_qtidisplay_shift_vertical := $(TARGET_DISPLAY_SHIFT_VERTICAL)
endif

ifeq ($(TARGET_HAS_WIDE_COLOR_DISPLAY), true)
    SOONG_CONFIG_qtidisplay_wide_color := true
endif

ifeq ($(TARGET_USES_FOD_ZPOS),true)
    SOONG_CONFIG_qtidisplay_udfps := true
endif

ifneq ($(TARGET_KERNEL_VERSION),)
    SOONG_CONFIG_qtidisplay_target_kernel_version := $(TARGET_KERNEL_VERSION)
endif

# For libgrallocutils features
ifeq ($(TARGET_NO_RAW10_CUSTOM_FORMAT),true)
    SOONG_CONFIG_qtidisplay_target_no_raw10_custom_format := true
endif

ifeq ($(TARGET_USES_ALIGNED_YCBCR_HEIGHT),true)
    SOONG_CONFIG_qtidisplay_target_uses_aligned_ycbcr_height := true
endif

ifeq ($(TARGET_USES_ALIGNED_YCRCB_HEIGHT),true)
    SOONG_CONFIG_qtidisplay_target_uses_aligned_ycrcb_height := true
endif

ifeq ($(TARGET_USES_UNALIGNED_NV21_ZSL),true)
    SOONG_CONFIG_qtidisplay_target_uses_unaligned_nv21_zsl := true
endif

ifeq ($(TARGET_USES_UNALIGNED_YCRCB),true)
    SOONG_CONFIG_qtidisplay_target_uses_unaligned_ycrcb := true
endif

ifeq ($(TARGET_USES_YCRCB_CAMERA_PREVIEW),true)
    SOONG_CONFIG_qtidisplay_target_uses_ycrcb_camera_preview := true
else ifeq ($(TARGET_USES_YCRCB_VENUS_CAMERA_PREVIEW),true)
    SOONG_CONFIG_qtidisplay_target_uses_ycrcb_venus_camera_preview := true
endif

# Tell HALs that we're compiling an AOSP build with an in-line kernel
TARGET_COMPILE_WITH_MSM_KERNEL := true

# Enable media extensions
TARGET_USES_MEDIA_EXTENSIONS := true

# Allow building audio encoders
TARGET_USES_QCOM_MM_AUDIO := true

# Enable color metadata on UM platforms that support it
ifneq ($(filter msm8937 msm8953 msm8996,$(TARGET_BOARD_PLATFORM)),)
    TARGET_USES_COLOR_METADATA := true
endif

# Enable DRM PP driver on UM platforms that support it
ifneq ($(filter $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY) $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    SOONG_CONFIG_qtidisplay_drmpp := true
endif

# Enable Gralloc4 on UM platforms that support it
ifneq ($(filter $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY) $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    SOONG_CONFIG_qtidisplay_gralloc4 := true
endif

# Select AR variant of A-HAL dependencies
ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY) $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    TARGET_USES_QCOM_AUDIO_AR ?= true
endif

# Enable displayconfig on every UM platform
ifeq ($(filter $(UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
    SOONG_CONFIG_qtidisplay_displayconfig_enabled := true
endif

# Enable SMMU proxy on UM platforms that support it
ifneq ($(filter $(UM_6_1_FAMILY) $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    SOONG_CONFIG_qtidisplay_smmu_proxy := true
endif

# Expose UBWCP headers to UM platforms that require it
ifneq ($(filter $(UM_6_1_FAMILY) $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    SOONG_CONFIG_qtidisplay_ubwcp_headers := true
endif

TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS ?= 0

# Mark GRALLOC_USAGE_EXTERNAL_DISP as valid gralloc bit
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 13)

# Mark GRALLOC_USAGE_PRIVATE_WFD as valid gralloc bit
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 21)

# Mark GRALLOC_USAGE_PRIVATE_HEIF_VIDEO as valid gralloc bit on UM platforms that support it
ifneq ($(filter $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY) $(UM_5_4_FAMILY) $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY) $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 27)
endif

# Enable master side content protection on UM platforms that support it
MASTER_SIDE_CP_TARGET_LIST := msm8996 $(UM_4_4_FAMILY) $(UM_4_9_FAMILY) $(UM_4_14_FAMILY) $(UM_4_19_FAMILY)
ifneq ($(filter $(MASTER_SIDE_CP_TARGET_LIST),$(TARGET_BOARD_PLATFORM)),)
    SOONG_CONFIG_qtidisplay_master_side_cp := true
endif

# Opt-in for old rmnet_data driver
ifeq ($(filter $(UM_5_15_FAMILY) $(UM_6_1_FAMILY) $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    $(call soong_config_set,rmnetctl,old_rmnet_data,true)
endif

# Use full QTI gralloc struct for GKI 2.0 targets
ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY) $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    TARGET_GRALLOC_HANDLE_HAS_CUSTOM_CONTENT_MD_RESERVED_SIZE ?= true
    TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE ?= true
else
    TARGET_GRALLOC_HANDLE_HAS_CUSTOM_CONTENT_MD_RESERVED_SIZE ?= false
    TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE ?= false
endif

# Use QTI gralloc UBWCP struct
ifneq ($(filter $(UM_6_1_FAMILY) $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    TARGET_GRALLOC_HANDLE_HAS_UBWCP_FORMAT ?= true
else
    TARGET_GRALLOC_HANDLE_HAS_UBWCP_FORMAT ?= false
endif

$(call soong_config_set,qtidisplay,gralloc_handle_has_custom_content_md_reserved_size,$(TARGET_GRALLOC_HANDLE_HAS_CUSTOM_CONTENT_MD_RESERVED_SIZE))
$(call soong_config_set,qtidisplay,gralloc_handle_has_reserved_size,$(TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE))
$(call soong_config_set,qtidisplay,gralloc_handle_has_ubwcp_format,$(TARGET_GRALLOC_HANDLE_HAS_UBWCP_FORMAT))

ifneq ($(filter $(UM_3_18_HAL_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := msm8996
else ifneq ($(filter $(UM_4_9_LEGACY_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := msm8953
else ifneq ($(filter $(UM_4_4_HAL_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := msm8998
else ifneq ($(filter $(UM_4_19_LEGACY_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sdm660
else ifneq ($(filter $(UM_4_9_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sdm845
else ifneq ($(filter $(UM_4_14_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8150
else ifneq ($(filter $(UM_4_19_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8250
else ifneq ($(filter $(UM_5_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8350
else ifneq ($(filter $(UM_5_10_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8450
else ifneq ($(filter $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8550
else ifneq ($(filter $(UM_6_1_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8650
else ifneq ($(filter $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
    QCOM_HARDWARE_VARIANT := sm8750
else
    QCOM_HARDWARE_VARIANT := $(TARGET_BOARD_PLATFORM)
endif

# Pass board platform to kernel build
TARGET_KERNEL_ADDITIONAL_FLAGS += TARGET_BOARD_PLATFORM=$(TARGET_BOARD_PLATFORM)

# Allow a device to opt-out hardset of PRODUCT_SOONG_NAMESPACES
QCOM_SOONG_NAMESPACE ?= hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)
PRODUCT_SOONG_NAMESPACES += $(QCOM_SOONG_NAMESPACE)

# Add bootctrl to PRODUCT_SOONG_NAMESPACES
PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/bootctrl

# Add display-commonsys to PRODUCT_SOONG_NAMESPACES for QSSI supported platforms
ifneq ($(filter $(QSSI_SUPPORTED_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
    PRODUCT_SOONG_NAMESPACES += \
        vendor/qcom/opensource/commonsys/display \
        vendor/qcom/opensource/commonsys-intf/display

    ifeq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY) $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
        PRODUCT_SOONG_NAMESPACES += \
            vendor/qcom/opensource/display
    endif
    $(call soong_config_set,qtidisplay,headers_namespace,vendor/qcom/opensource/commonsys-intf/display)
else
    $(call soong_config_set,qtidisplay,headers_namespace,$(QCOM_SOONG_NAMESPACE)/display)
endif

# Add data-ipa-cfg-mgr to PRODUCT_SOONG_NAMESPACES if needed
ifneq ($(USE_DEVICE_SPECIFIC_DATA_IPA_CFG_MGR),true)
    ifneq ($(filter $(LEGACY_UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
        PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr-legacy-um
    else ifneq ($(filter $(UM_5_10_FAMILY),$(TARGET_BOARD_PLATFORM)),)
        PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/sm8450/data-ipa-cfg-mgr
    else ifneq ($(filter $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
        PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/sm8550/data-ipa-cfg-mgr
    else ifneq ($(filter $(UM_6_1_FAMILY),$(TARGET_BOARD_PLATFORM)),)
        PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/sm8650/data-ipa-cfg-mgr
    else ifneq ($(filter $(UM_6_6_FAMILY),$(TARGET_BOARD_PLATFORM)),)
        PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/sm8750/data-ipa-cfg-mgr
    endif
endif

# Add dataservices to PRODUCT_SOONG_NAMESPACES if needed
ifneq ($(USE_DEVICE_SPECIFIC_DATASERVICES),true)
    PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/dataservices
endif

# Add sound trigger HAL to PRODUCT_SOONG_NAMESPACES if needed
ifeq ($(BOARD_SUPPORTS_OPENSOURCE_STHAL),true)
    ifneq ($(filter $(LEGACY_UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
        PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/audio-hal/st-hal
    else
        ifneq ($(filter $(UM_5_10_FAMILY) $(UM_5_15_FAMILY) $(UM_6_1_FAMILY),$(TARGET_BOARD_PLATFORM)),)
            PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/audio-hal/st-hal-ar-legacy
            $(call soong_config_set,qtiaudio,legacy_headers_namespace,$(QCOM_SOONG_NAMESPACE))
            $(call soong_config_set,qtiaudio,legacy_libarpal_namespace,$(QCOM_SOONG_NAMESPACE))
        else
            PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/audio-hal/st-hal-ar
            $(call soong_config_set,qtiaudio,headers_namespace,$(QCOM_SOONG_NAMESPACE))
            $(call soong_config_set,qtiaudio,libarpal_namespace,$(QCOM_SOONG_NAMESPACE))
        endif
    endif
endif

# Add thermal HAL to PRODUCT_SOONG_NAMESPACES
ifneq ($(filter $(LEGACY_UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
    PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/thermal-legacy-um
else
    PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/thermal
endif

# Add wlan to PRODUCT_SOONG_NAMESPACES
PRODUCT_SOONG_NAMESPACES += \
    hardware/qcom-caf/wlan \
    hardware/qcom-caf/wlan/qcwcn

# Verified Boot
BOARD_AVB_SYSTEM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_EXT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_OTHER_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_ODM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_ODM_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_PRODUCT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
