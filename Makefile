include $(THEOS)/makefiles/common.mk

TARGET = iphone::9.2:9.0
SDKVERSION = 9.2
SYSROOT = /Users/josephshenton/theos/sdks/iPhoneOS9.2.sdk 
TWEAK_NAME = badiOSbad
badiOSbad_FILES = Tweak.xm
# $(TWEAK_NAME)_LDFlags = -L
# $(TWEAK_NAME)_FRAMEWORKS = StartApp AdSupport AVFoundation CFNetwork CoreGraphics CoreMedia CoreTelephony MobileCoreServices QuartzCore Security SystemConfiguration WebKit StoreKit
# $(TWEAK_NAME)_LIBRARIES = libz
$(TWEAK_NAME)_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
