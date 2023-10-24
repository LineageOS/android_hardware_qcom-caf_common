# Platform name variables - used in makefiles everywhere
KONA := kona #SM8250
LITO := lito #SM7250
BENGAL := bengal #SM6115
MSMNILE := msmnile #SM8150
MSMSTEPPE := sm6150
TRINKET := trinket #SM6125
ATOLL := atoll #SM6250
LAHAINA := lahaina #SM8350
HOLI := holi #SM4350
TARO := taro #SM8450
PARROT := parrot #SM6450
KALAMA := kalama #SM8550

# UM Family
UM_3_18_FAMILY := msm8996
UM_4_4_FAMILY := msm8998
UM_4_9_FAMILY := sdm845 sdm710
UM_4_14_FAMILY := $(MSMNILE) $(MSMSTEPPE) $(TRINKET) $(ATOLL)
UM_4_19_FAMILY := $(KONA) $(LITO) $(BENGAL)
UM_5_4_FAMILY := $(LAHAINA) $(HOLI)
UM_5_10_FAMILY := $(TARO) $(PARROT)
UM_5_15_FAMILY := $(KALAMA)
