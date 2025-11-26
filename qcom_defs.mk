# Platform name variables - used in makefiles everywhere
MSMSTEPPE := sm6150
TRINKET := trinket #SM6125

# UM families
UM_3_18_FAMILY := msm8996 msm8937 msm8953
UM_4_4_FAMILY := msm8998 sdm660
UM_4_9_FAMILY := sdm845 sdm710
UM_4_14_FAMILY := msmnile $(MSMSTEPPE) $(TRINKET) atoll
UM_4_19_FAMILY := kona lito bengal
UM_5_4_FAMILY := lahaina holi
UM_5_10_FAMILY := taro parrot
UM_5_15_FAMILY := kalama crow
UM_6_1_FAMILY := pineapple volcano
UM_6_6_FAMILY := sun

ifeq ($(call is-board-platform-in-list,$(UM_6_6_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 6.6
else ifeq ($(call is-board-platform-in-list,$(UM_6_1_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 6.1
else ifeq ($(call is-board-platform-in-list,$(UM_5_15_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.15
else ifeq ($(call is-board-platform-in-list,$(UM_5_10_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.10
else ifeq ($(call is-board-platform-in-list,$(UM_5_4_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.4
else ifeq ($(call is-board-platform-in-list,$(UM_4_19_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.19
else ifeq ($(call is-board-platform-in-list,$(UM_4_14_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.14
else ifeq ($(call is-board-platform-in-list,$(UM_4_9_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.9
else ifeq ($(call is-board-platform-in-list,$(UM_4_4_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.4
else ifeq ($(call is-board-platform-in-list,$(UM_3_18_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 3.18
endif
