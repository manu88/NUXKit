# A more complicated build file that is starting to look a lot like how
# Xcode internally structures its builds. The goal here is to show how
# one might actually go about building a full Xcode-capable build system
# without all of the requirements of Xcode, xcodebuild, and xcproj files.
#
# There will likely be limitations to this process, but lets see how far
# the wind takes us.

## USER CONFIGURABLE SETTINGS ##
CONFIG       = debug
PLATFORM     = macosx
ARCH         = x86_64
MODULE_NAME  = TestAPI
MACH_O_TYPE  = mh_execute

## GLOBAL SETTINGS ##
ROOT_DIR            = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BUILD_DIR           = $(ROOT_DIR)/bin
SRC_DIR             = $(ROOT_DIR)/TestAPI
LIB_DIR             = $(ROOT_DIR)/lib

TOOLCHAIN           = Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/$(PLATFORM)
TOOLCHAIN_PATH      = $(shell xcode-select --print-path)/$(TOOLCHAIN)

SWIFT               = $(shell xcrun -f swift) -frontend -c -color-diagnostics

## COMPILER SETTINGS ##
CFLAGS       = -g -Onone
SDK_PATH     = $(shell xcrun --show-sdk-path -sdk $(PLATFORM))

## LINKER SETTINGS ##
LD           = $(shell xcrun -f ld)
LDFLAGS      = -syslibroot $(SDK_PATH) -lSystem -arch $(ARCH) \
                -macosx_version_min 10.10.0 \
                -no_objc_category_merging -L $(TOOLCHAIN_PATH) \
                -rpath $(TOOLCHAIN_PATH)
OBJ_EXT      = 
OBJ_PRE      =

ifeq (mh_dylib, $(MACH_O_TYPE))
    OBJ_EXT  = .dylib
    OBJ_PRE  = lib
    LDFLAGS += -dylib
endif

## BUILD LOCATIONS ##
PLATFORM_BUILD_DIR    = $(BUILD_DIR)/$(MODULE_NAME)/bin/$(CONFIG)/$(PLATFORM)
PLATFORM_OBJ_DIR      = $(BUILD_DIR)/$(MODULE_NAME)/obj/$(CONFIG)/$(PLATFORM)
PLATFORM_TEMP_DIR     = $(BUILD_DIR)/$(MODULE_NAME)/tmp/$(CONFIG)/$(PLATFORM)

SOURCE =  AppDelegate.swift main.swift ViewController.swift UIKit/UIWindow.swift \
		UIKit/UIApplication.swift \
		UIKit/UIResponder.swift \
		UIKit/UIView.swift \

# $(wildcard $(SRC_DIR)/*.swift) $(wildcard $(SRC_DIR)/*/*.swift)

## BUILD TARGETS ##
tool: setup $(SOURCE) link

## COMPILE RULES FOR FILES ##


%.cpp:
	xcrun -sdk macosx swiftc -import-objc-header TestAPI/UIKit/TestAPI-Bridging-Header.h -o $@ $^

%.swift:
	$(SWIFT) $(CFLAGS) -primary-file $(SRC_DIR)/$@ \
		$(addprefix $(SRC_DIR)/,$(filter-out $@,$(SOURCE))) -sdk $(SDK_PATH) \
		-module-name $(MODULE_NAME) -o $(PLATFORM_OBJ_DIR)/$*.o -emit-module \
		-emit-module-path $(PLATFORM_OBJ_DIR)/$*~partial.swiftmodule


main.swift:
	$(SWIFT) $(CFLAGS) -primary-file $(SRC_DIR)/main.swift \
        $(addprefix $(SRC_DIR)/,$(filter-out $@,$(SOURCE))) -sdk $(SDK_PATH) \
        -module-name $(MODULE_NAME) -o $(PLATFORM_OBJ_DIR)/main.o -emit-module \
        -emit-module-path $(PLATFORM_OBJ_DIR)/main~partial.swiftmodule

link:
	$(LD) $(LDFLAGS) $(wildcard $(PLATFORM_OBJ_DIR)/*.o) \
        -o $(PLATFORM_BUILD_DIR)/$(OBJ_PRE)$(MODULE_NAME)$(OBJ_EXT)

setup:
    $(shell mkdir -p $(PLATFORM_BUILD_DIR))
    $(shell mkdir -p $(PLATFORM_OBJ_DIR))
    $(shell mkdir -p $(PLATFORM_TEMP_DIR))
