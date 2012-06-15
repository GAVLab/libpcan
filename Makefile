all: installed

TARBALL = build/peak-linux-driver-6.24.tar.gz
TARBALL_URL = https://code.ros.org/svn/release/download/thirdparty/peak-linux-driver-6.24.tar.gz
SOURCE_DIR = build/peak-linux-driver-6.24
MD5SUM_FILE = peak-linux-driver-6.24.tar.gz.md5sum
KERNEL_VER=/usr/src/linux-headers-"`uname -r`"

include $(shell rospack find mk)/download_unpack_build.mk

installed: $(SOURCE_DIR)/unpacked
	# build
	cd $(SOURCE_DIR) && make KERNEL_LOCATION=$(KERNEL_VER) DBG=NO_DEBUG MOD=MODVERSIONS PAR=PARPORT_SUBSYSTEM USB=USB_SUPPORT PCI=PCI_SUPPORT DNG=DONGLE_SUPPORT ISA=NO_ISA_SUPPORT PCC=NO_PCCARD_SUPPORT NET=NO_NETDEV_SUPPORT RT=NO_RT

	# copy to common
	mkdir -p common
	mkdir -p common/lib
	mkdir -p common/include
	mkdir -p common/include/libpcan	
	cp $(SOURCE_DIR)/lib/*.so* common/lib
	cp common/lib/libpcan.so common/lib/libpcan.so.0
	cp $(SOURCE_DIR)/lib/*.h common/include/libpcan
	cp $(SOURCE_DIR)/driver/*.h common/include/libpcan
clean:
	rm -rf common $(SOURCE_DIR) $(TARBALL)
wipe: clean
	-rm -rf build

include $(shell rospack find mk)/cmake.mk
