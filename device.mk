# call the proprietary setup
$(call inherit-product, vendor/xiaomi/cancro/cancro-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/xiaomi/cancro/overlay

LOCAL_PATH := device/xiaomi/cancro

# This device is xxhdpi.  However the platform doesn't
# currently contain all of the bitmaps at xxhdpi density so
# we do this little trick to fall back to the xhdpi version
# if the xxhdpi doesn't exist.
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi xxhdpi
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

TARGET_USES_QCOM_BSP := true
TARGET_USES_QCA_NFC := other

ifeq ($(TARGET_USES_QCOM_BSP), true)
# Add QC Video Enhancements flag
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
endif #TARGET_USES_QCOM_BSP

# media_profiles and media_codecs xmls for 8974
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/media/media_profiles_8974.xml:system/etc/media_profiles.xml \
                      $(LOCAL_PATH)/media/media_codecs_8974.xml:system/etc/media_codecs.xml \
                      $(LOCAL_PATH)/media/media_codecs_performance_8974.xml:system/etc/media_codecs_performance.xml
endif  #TARGET_ENABLE_QC_AV_ENHANCEMENTS

PRODUCT_PROPERTY_OVERRIDES += \
       dalvik.vm.heapminfree=2m
$(call inherit-product, device/qcom/common/common.mk)

# Audio configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    $(LOCAL_PATH)/mixer_paths.xml:system/etc/mixer_paths.xml \
    $(LOCAL_PATH)/mixer_paths_auxpcm.xml:system/etc/mixer_paths_auxpcm.xml

# Audio calibration data
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/acdb/MTP/MTP_Bluetooth_cal.acdb:system/etc/acdbdata/MTP/MTP_Bluetooth_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/MTP/MTP_General_cal.acdb:system/etc/acdbdata/MTP/MTP_General_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/MTP/MTP_Global_cal.acdb:system/etc/acdbdata/MTP/MTP_Global_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/MTP/MTP_Handset_cal.acdb:system/etc/acdbdata/MTP/MTP_Handset_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/MTP/MTP_Hdmi_cal.acdb:system/etc/acdbdata/MTP/MTP_Hdmi_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/MTP/MTP_Headset_cal.acdb:system/etc/acdbdata/MTP/MTP_Headset_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/MTP/MTP_Speaker_cal.acdb:system/etc/acdbdata/MTP/MTP_Speaker_cal.acdb


PRODUCT_PACKAGES += \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libqcompostprocbundle

#camera
PRODUCT_PACKAGES += \
    camera.msm8974

# Feature definition files for 8974
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml

#battery_monitor
PRODUCT_PACKAGES += \
    battery_monitor \
    battery_shutdown

#fstab.qcom
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.recovery.hardware

#keylayout
PRODUCT_PACKAGES += \
    cyttsp_button.kl \
    fts.kl \
    msm8974-taiko-mtp-snd-card_Button_Jack.kl \
    synaptics_dsx.kl

#wlan driver
PRODUCT_COPY_FILES += \
    kernel/xiaomi/cancro/drivers/staging/prima/firmware_bin/WCNSS_cfg.dat:system/etc/firmware/wlan/prima/WCNSS_cfg.dat \
    kernel/xiaomi/cancro/drivers/staging/prima/firmware_bin/WCNSS_qcom_cfg.ini:system/etc/firmware/wlan/prima/WCNSS_qcom_cfg.ini

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf \
    WCNSS_qcom_wlan_nv.bin \
    WCNSS_qcom_wlan_nv_x4.bin \
    WCNSS_qcom_wlan_nv_x4lte.bin

PRODUCT_PACKAGES += wcnss_service

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml

#ANT stack
PRODUCT_PACKAGES += \
        AntHalService \
        libantradio \
        ANTRadioService \
        antradio_app

# Enable strict operation
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.strict_op_enable=false

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.whitelist=/system/etc/whitelist_appops.xml

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    camera2.portability.force_api=1

# Debuggable by default
PRODUCT_PROPERTY_OVERRIDES += \
    persist.service.adb.enable=1 \
    persist.service.debuggable=1 \
    persist.sys.usb.config=mtp,adb \
    ro.build.selinux=1 \
    ro.secure=0

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/whitelist_appops.xml:system/etc/whitelist_appops.xml

# NFC packages
ifeq ($(TARGET_USES_QCA_NFC),true)
NFC_D := true

ifeq ($(NFC_D), true)
    PRODUCT_PACKAGES += \
        libnfcD-nci \
        libnfcD_nci_jni \
        nfc_nci.msm8974 \
        NfcDNci \
        Tag \
        com.android.nfc_extras \
        com.android.nfc.helper
else
PRODUCT_PACKAGES += \
    libnfc-nci \
    libnfc_nci_jni \
    nfc_nci.msm8974 \
    NfcNci \
    Tag \
    com.android.nfc_extras
endif

# file that declares the MIFARE NFC constant
# Commands to migrate prefs from com.android.nfc3 to com.android.nfc
# NFC access control + feature files + configuration
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/com.nxp.mifare.xml:system/etc/permissions/com.nxp.mifare.xml \
        frameworks/native/data/etc/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml \
        frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml
# Enable NFC Forum testing by temporarily changing the PRODUCT_BOOT_JARS
# line has to be in sync with build/target/product/core_base.mk
endif

#PRODUCT_BOOT_JARS += org.codeaurora.Performance \
                     vcard \

PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += qcmediaplayer

ifneq ($(strip $(QCPATH)),)
PRODUCT_BOOT_JARS += WfdCommon
PRODUCT_BOOT_JARS += qcom.fmradio
PRODUCT_BOOT_JARS += oem-services
PRODUCT_BOOT_JARS += com.qti.dpmframework
PRODUCT_BOOT_JARS += dpmapi
PRODUCT_BOOT_JARS += com.qti.location.sdk
endif
