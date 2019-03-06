From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Subject: [PATCH] drivers: scsi: Kconfig: pedantic cleanups
Date: Wed,  6 Mar 2019 19:53:04 +0100
Message-ID: <1551898384-19624-1-git-send-email-info@metux.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, ooo@electrozaur.com, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 drivers/scsi/Kconfig          | 63 +++++++++++++++++++++----------------------
 drivers/scsi/osd/Kconfig      | 38 +++++++++++++-------------
 drivers/scsi/pcmcia/Kconfig   |  2 +-
 drivers/scsi/qedf/Kconfig     |  8 +++---
 drivers/scsi/smartpqi/Kconfig | 16 +++++------
 5 files changed, 63 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index f38882f..7a9eab1 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1,9 +1,9 @@
 menu "SCSI device support"
 
 config SCSI_MOD
-       tristate
-       default y if SCSI=n || SCSI=y
-       default m if SCSI=m
+	tristate
+	default y if SCSI=n || SCSI=y
+	default m if SCSI=m
 
 config RAID_ATTRS
 	tristate "RAID Transport Class"
@@ -47,7 +47,7 @@ config SCSI_ESP_PIO
 
 config SCSI_NETLINK
 	bool
-	default	n
+	default n
 	depends on NET
 
 config SCSI_PROC_FS
@@ -307,25 +307,25 @@ config ISCSI_TCP
 	select CRYPTO_CRC32C
 	select SCSI_ISCSI_ATTRS
 	help
-	 The iSCSI Driver provides a host with the ability to access storage
-	 through an IP network. The driver uses the iSCSI protocol to transport
-	 SCSI requests and responses over a TCP/IP network between the host
-	 (the "initiator") and "targets".  Architecturally, the iSCSI driver
-	 combines with the host's TCP/IP stack, network drivers, and Network
-	 Interface Card (NIC) to provide the same functions as a SCSI or a
-	 Fibre Channel (FC) adapter driver with a Host Bus Adapter (HBA).
+	  The iSCSI Driver provides a host with the ability to access storage
+	  through an IP network. The driver uses the iSCSI protocol to transport
+	  SCSI requests and responses over a TCP/IP network between the host
+	  (the "initiator") and "targets".  Architecturally, the iSCSI driver
+	  combines with the host's TCP/IP stack, network drivers, and Network
+	  Interface Card (NIC) to provide the same functions as a SCSI or a
+	  Fibre Channel (FC) adapter driver with a Host Bus Adapter (HBA).
 
-	 To compile this driver as a module, choose M here: the
-	 module will be called iscsi_tcp.
+	  To compile this driver as a module, choose M here: the
+	  module will be called iscsi_tcp.
 
-	 The userspace component needed to initialize the driver, documentation,
-	 and sample configuration files can be found here:
+	  The userspace component needed to initialize the driver, documentation,
+	  and sample configuration files can be found here:
 
-	 http://open-iscsi.org
+	  http://open-iscsi.org
 
 config ISCSI_BOOT_SYSFS
 	tristate "iSCSI Boot Sysfs Interface"
-	default	n
+	default n
 	help
 	  This option enables support for exposing iSCSI boot information
 	  via sysfs to userspace. If you wish to export this information,
@@ -340,7 +340,7 @@ source "drivers/scsi/cxlflash/Kconfig"
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
 	depends on SGI_HAS_WD93 && SCSI
-  	help
+	help
 	  If you have a Western Digital WD93 SCSI controller on
 	  an SGI MIPS system, say Y.  Otherwise, say N.
 
@@ -455,7 +455,6 @@ config SCSI_AACRAID
 	  To compile this driver as a module, choose M here: the module
 	  will be called aacraid.
 
-
 source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"
 source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
 source "drivers/scsi/aic94xx/Kconfig"
@@ -475,7 +474,7 @@ config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
 	depends on SCSI && PCI && VIRT_TO_BUS
 	help
-	  This driver supports all of Adaptec's I2O based RAID controllers as 
+	  This driver supports all of Adaptec's I2O based RAID controllers as
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
 	  driver by Deanna Bonds.  See <file:Documentation/scsi/dpti.txt>.
 
@@ -669,7 +668,7 @@ config SCSI_GDTH
 	---help---
 	  Formerly called GDT SCSI Disk Array Controller Support.
 
-	  This is a driver for RAID/SCSI Disk Array Controllers (EISA/ISA/PCI) 
+	  This is a driver for RAID/SCSI Disk Array Controllers (EISA/ISA/PCI)
 	  manufactured by Intel Corporation/ICP vortex GmbH. It is documented
 	  in the kernel source in <file:drivers/scsi/gdth.c> and
 	  <file:drivers/scsi/gdth.h>.
@@ -1152,8 +1151,8 @@ config SCSI_LPFC
 	depends on NVME_FC || NVME_FC=n
 	select CRC_T10DIF
 	---help---
-          This lpfc driver supports the Emulex LightPulse
-          Family of Fibre Channel PCI host adapters.
+	  This lpfc driver supports the Emulex LightPulse
+	  Family of Fibre Channel PCI host adapters.
 
 config SCSI_LPFC_DEBUG_FS
 	bool "Emulex LightPulse Fibre Channel debugfs Support"
@@ -1468,14 +1467,14 @@ config ZFCP
 	depends on S390 && QDIO && SCSI
 	depends on SCSI_FC_ATTRS
 	help
-          If you want to access SCSI devices attached to your IBM eServer
-          zSeries by means of Fibre Channel interfaces say Y.
-          For details please refer to the documentation provided by IBM at
-          <http://oss.software.ibm.com/developerworks/opensource/linux390>
+	  If you want to access SCSI devices attached to your IBM eServer
+	  zSeries by means of Fibre Channel interfaces say Y.
+	  For details please refer to the documentation provided by IBM at
+	  <http://oss.software.ibm.com/developerworks/opensource/linux390>
 
-          This driver is also available as a module. This module will be
-          called zfcp. If you want to compile it as a module, say M here
-          and read <file:Documentation/kbuild/modules.txt>.
+	  This driver is also available as a module. This module will be
+	  called zfcp. If you want to compile it as a module, say M here
+	  and read <file:Documentation/kbuild/modules.txt>.
 
 config SCSI_PMCRAID
 	tristate "PMC SIERRA Linux MaxRAID adapter support"
@@ -1506,8 +1505,8 @@ config SCSI_VIRTIO
 	tristate "virtio-scsi support"
 	depends on VIRTIO
 	help
-          This is the virtual HBA driver for virtio.  If the kernel will
-          be used in a virtual machine, say Y or M.
+	  This is the virtual HBA driver for virtio.  If the kernel will
+	  be used in a virtual machine, say Y or M.
 
 source "drivers/scsi/csiostor/Kconfig"
 
diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
index 347cc5e..90b08c3 100644
--- a/drivers/scsi/osd/Kconfig
+++ b/drivers/scsi/osd/Kconfig
@@ -15,35 +15,35 @@ config SCSI_OSD_INITIATOR
 	tristate "OSD-Initiator library"
 	depends on SCSI
 	help
-		Enable the OSD-Initiator library (libosd.ko).
-		NOTE: You must also select CRYPTO_SHA1 + CRYPTO_HMAC and their
-		dependencies
+	  Enable the OSD-Initiator library (libosd.ko).
+	  NOTE: You must also select CRYPTO_SHA1 + CRYPTO_HMAC and their
+	  dependencies
 
 config SCSI_OSD_ULD
 	tristate "OSD Upper Level driver"
 	depends on SCSI_OSD_INITIATOR
 	help
-		Build a SCSI upper layer driver that exports /dev/osdX devices
-		to user-mode for testing and controlling OSD devices. It is also
-		needed by exofs, for mounting an OSD based file system.
+	  Build a SCSI upper layer driver that exports /dev/osdX devices
+	  to user-mode for testing and controlling OSD devices. It is also
+	  needed by exofs, for mounting an OSD based file system.
 
 config SCSI_OSD_DPRINT_SENSE
-    int "(0-2) When sense is returned, DEBUG print all sense descriptors"
-    default 1
-    depends on SCSI_OSD_INITIATOR
-    help
-        When a CHECK_CONDITION status is returned from a target, and a
-        sense-buffer is retrieved, turning this on will dump a full
-        sense-decoding message. Setting to 2 will also print recoverable
-        errors that might be regularly returned for some filesystem
-        operations.
+	int "(0-2) When sense is returned, DEBUG print all sense descriptors"
+	default 1
+	depends on SCSI_OSD_INITIATOR
+	help
+	  When a CHECK_CONDITION status is returned from a target, and a
+	  sense-buffer is retrieved, turning this on will dump a full
+	  sense-decoding message. Setting to 2 will also print recoverable
+	  errors that might be regularly returned for some filesystem
+	  operations.
 
 config SCSI_OSD_DEBUG
 	bool "Compile All OSD modules with lots of DEBUG prints"
 	default n
 	depends on SCSI_OSD_INITIATOR
 	help
-		OSD Code is populated with lots of OSD_DEBUG(..) printouts to
-		dmesg. Enable this if you found a bug and you want to help us
-		track the problem (see also MAINTAINERS). Setting this will also
-		force SCSI_OSD_DPRINT_SENSE=2.
+	  OSD Code is populated with lots of OSD_DEBUG(..) printouts to
+	  dmesg. Enable this if you found a bug and you want to help us
+	  track the problem (see also MAINTAINERS). Setting this will also
+	  force SCSI_OSD_DPRINT_SENSE=2.
diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index 2d435f1..b63b34d 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -32,7 +32,7 @@ config PCMCIA_NINJA_SCSI
 	  NinjaSCSI-3: (version string: "WBT","NinjaSCSI-3","R1.0")
 	    IO-DATA     PCSC-FP
 	    ALPHA DATA  AD-PCS201
-	    CyQ've      SFC-201  
+	    CyQ've      SFC-201
 	    LOGITECH    LPM-SCSI2E
 	    Pioneer PCR-PR24's card
 	    I-O DATA CDPS-PX24's card (PCSC-F)
diff --git a/drivers/scsi/qedf/Kconfig b/drivers/scsi/qedf/Kconfig
index 943f5ee..e2693db 100644
--- a/drivers/scsi/qedf/Kconfig
+++ b/drivers/scsi/qedf/Kconfig
@@ -2,10 +2,10 @@ config QEDF
 	tristate "QLogic QEDF 25/40/100Gb FCoE Initiator Driver Support"
 	depends on PCI && SCSI
 	depends on QED
-        depends on LIBFC
-        depends on LIBFCOE
+	depends on LIBFC
+	depends on LIBFCOE
 	select QED_LL2
 	select QED_FCOE
 	---help---
-	This driver supports FCoE offload for the QLogic FastLinQ
-	41000 Series Converged Network Adapters.
+	  This driver supports FCoE offload for the QLogic FastLinQ
+	  41000 Series Converged Network Adapters.
diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
index 97e159c..fafc7f7 100644
--- a/drivers/scsi/smartpqi/Kconfig
+++ b/drivers/scsi/smartpqi/Kconfig
@@ -41,14 +41,14 @@ config SCSI_SMARTPQI
 	select SCSI_SAS_ATTRS
 	select RAID_ATTRS
 	---help---
-	This driver supports Microsemi PQI controllers.
+	  This driver supports Microsemi PQI controllers.
 
-	<http://www.microsemi.com>
+	  <http://www.microsemi.com>
 
-	To compile this driver as a module, choose M here: the
-	module will be called smartpqi.
+	  To compile this driver as a module, choose M here: the
+	  module will be called smartpqi.
 
-        Note: the aacraid driver will not manage a smartpqi
-              controller. You need to enable smartpqi for smartpqi
-              controllers. For more information, please see
-              Documentation/scsi/smartpqi.txt
+	  Note: the aacraid driver will not manage a smartpqi
+	        controller. You need to enable smartpqi for smartpqi
+	        controllers. For more information, please see
+	        Documentation/scsi/smartpqi.txt
-- 
1.9.1
