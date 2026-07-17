# Platform name variables - used in makefiles everywhere
MSMSTEPPE := sm6150
TRINKET := trinket #SM6125

# UM families
UM_3_18_FAMILY := msm8996 $(if $(TARGET_ENFORCES_QSSI)),msm8937 msm8953,)
UM_4_4_FAMILY := msm8998 $(if $(TARGET_ENFORCES_QSSI)),sdm660,)
UM_4_9_FAMILY := sdm845 sdm710
UM_4_9_LEGACY_FAMILY := $(if $(TARGET_ENFORCES_QSSI)),,msm8937 msm8953)
UM_4_14_FAMILY := msmnile $(MSMSTEPPE) $(TRINKET) atoll
UM_4_19_FAMILY := kona lito bengal
UM_4_19_LEGACY_FAMILY := $(if $(TARGET_ENFORCES_QSSI)),,sdm660)
UM_5_4_FAMILY := lahaina holi
UM_5_10_FAMILY := taro parrot
UM_5_15_FAMILY := kalama crow
UM_6_1_FAMILY := pineapple volcano
UM_6_6_FAMILY := sun

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

define get-platform-hardware
$(strip \
    $(if $(filter $(UM_3_18_FAMILY),$(1)),msm8996,\
    $(if $(filter $(UM_4_4_FAMILY),$(1)),msm8998,\
    $(if $(filter $(UM_4_9_LEGACY_FAMILY),$(1)),msm8953,\
    $(if $(filter $(UM_4_19_LEGACY_FAMILY),$(1)),sdm660,\
    $(if $(filter $(UM_4_9_FAMILY),$(1)),sdm845,\
    $(if $(filter $(UM_4_14_FAMILY),$(1)),sm8150,\
    $(if $(filter $(UM_4_19_FAMILY),$(1)),sm8250,\
    $(if $(filter $(UM_5_4_FAMILY),$(1)),sm8350,\
    $(if $(filter $(UM_5_10_FAMILY),$(1)),sm8450,\
    $(if $(filter $(UM_5_15_FAMILY),$(1)),sm8550,\
    $(if $(filter $(UM_6_1_FAMILY),$(1)),sm8650,\
    $(if $(filter $(UM_6_6_FAMILY),$(1)),sm8750,\
    $(1))))))))))))))
endef
QCOM_HARDWARE_VARIANT := $(call get-platform-hardware,$(TARGET_BOARD_PLATFORM))

define check-platform-upgrade
    ifneq ($$(filter $$(UM_$(subst .,_,$(1))_FAMILY),$$(TARGET_BOARD_PLATFORM)),)
        ifneq ($(2),$(1))
            ifneq ($$(wildcard hardware/qcom-caf/$$(QCOM_HARDWARE_VARIANT)-$(2)),)
                UM_$(subst .,_,$(1))_FAMILY := $$(subst $$(TARGET_BOARD_PLATFORM),,$$(UM_$(subst .,_,$(1))_FAMILY))
                UM_$(subst .,_,$(2))_FAMILY += $$(TARGET_BOARD_PLATFORM)
                QCOM_HARDWARE_VARIANT := $$(QCOM_HARDWARE_VARIANT)-$(2)
            endif
        endif
    endif
endef

KERNEL_VERSIONS_LIST := 3.18 4.4 4.9 4.14 4.19 5.4 5.10 5.15 6.1 6.6
$(foreach ver,$(KERNEL_VERSIONS_LIST),\
    $(eval $(call check-platform-upgrade,$(ver),$(TARGET_KERNEL_VERSION))))
