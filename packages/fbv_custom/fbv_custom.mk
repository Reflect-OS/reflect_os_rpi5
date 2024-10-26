################################################################################
#
# fbv
#
################################################################################

FBV_CUSTOM_VERSION = 1.0b
FBV_CUSTOM_SITE = https://sources.buildroot.net/fbv/fbv-1.0b.tar.gz

FBV_CUSTOM_LICENSE = GPL-2.0
FBV_CUSTOM_LICENSE_FILES = COPYING

### image format dependencies and configure options
FBV_CUSTOM_DEPENDENCIES = # empty
FBV_CUSTOM_CONFIGURE_OPTS = # empty
ifeq ($(BR2_PACKAGE_FBV_CUSTOM_PNG),y)
FBV_CUSTOM_DEPENDENCIES += libpng

# libpng in turn depends on other libraries
ifeq ($(BR2_STATIC_LIBS),y)
FBV_CUSTOM_CONFIGURE_OPTS += "--libs=`$(PKG_CONFIG_HOST_BINARY) --libs libpng`"
endif

else
FBV_CUSTOM_CONFIGURE_OPTS += --without-libpng
endif
ifeq ($(BR2_PACKAGE_FBV_CUSTOM_JPEG),y)
FBV_CUSTOM_DEPENDENCIES += jpeg
else
FBV_CUSTOM_CONFIGURE_OPTS += --without-libjpeg
endif
ifeq ($(BR2_PACKAGE_FBV_CUSTOM_GIF),y)
FBV_CUSTOM_DEPENDENCIES += giflib
else
FBV_CUSTOM_CONFIGURE_OPTS += --without-libungif
endif

#fbv doesn't support cross-compilation
define FBV_CUSTOM_CONFIGURE_CMDS
	(cd $(FBV_CUSTOM_DIR); rm -f config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--prefix=/usr \
		$(FBV_CUSTOM_CONFIGURE_OPTS) \
	)
endef

define FBV_CUSTOM_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define FBV_CUSTOM_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/fbv $(TARGET_DIR)/usr/bin/fbv
endef

$(eval $(autotools-package))
