From: Rusty Trivial Russell <trivial@rustcorp.com.au>
Subject: [TRIVIAL] Re: Remove modules.txt drivers_scsi_Kconfig II
Date: Thu, 11 Sep 2003 16:39:21 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030911064458.335DA2C26C@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:23229 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S266183AbTIKGo6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 02:44:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org
Cc: linux-scsi@vger.kernel.org, axboe@suse.de

[ modules.txt no longer exists.  Replace Kconfig references with new,
  shorter spiel --RR ]
From:  Nicolas Kaiser <nikai@nikai.net>

  Again. Please ignore previous patch.
  I had added a trailing space.
  
  Cheers, n.

--- trivial-2.6.0-test5-bk1/drivers/scsi/Kconfig.orig	2003-09-11 16:25:29.000000000 +1000
+++ trivial-2.6.0-test5-bk1/drivers/scsi/Kconfig	2003-09-11 16:25:29.000000000 +1000
@@ -14,13 +14,12 @@
 	  version of the IOMEGA ZIP drive, USB storage devices, Fibre
 	  Channel, FireWire storage and the IDE-SCSI emulation driver.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
+	  To compile this driver as a module, say M here and read
+	  <file:Documentation/scsi/scsi.txt>.
+	  The module will be called scsi_mod.
+
+	  However, do not compile this as a module if your root file system
+	  (the one containing the directory /) is located on a SCSI device.
 
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
@@ -47,14 +46,14 @@
 	  <http://www.tldp.org/docs.html#howto>. This is NOT for SCSI
 	  CD-ROMs.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called sd_mod.  If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  Do not compile this driver as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI disk. In this case, do not compile the driver
-	  for your SCSI host adapter (below) as a module either.
+	  To compile this driver as a module, say M here and read
+	  <file:Documentation/scsi/scsi.txt>.
+	  The module will be called sd_mod.
+
+	  Do not compile this driver as a module if your root file system
+	  (the one containing the directory /) is located on a SCSI disk.
+	  In this case, do not compile the driver for your SCSI host adapter
+	  (below) as a module either.
 
 config CHR_DEV_ST
 	tristate "SCSI tape support"
@@ -66,11 +65,8 @@
 	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT
 	  for SCSI CD-ROMs.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called st. If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.
+	  To compile this driver as a module, say M here and read
+	  <file:Documentation/scsi/scsi.txt>. The module will be called st.
 
 config CHR_DEV_OSST
 	tristate "SCSI OnStream SC-x0 tape support"
@@ -91,11 +87,8 @@
 	  Please also have a look at the standard st docu, as most of it
 	  applies to osst as well.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called osst. If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.
+	  To compile this driver as a module, say M here and read
+	  <file:Documentation/scsi/scsi.txt>. The module will be called osst.
 
 config BLK_DEV_SR
 	tristate "SCSI CDROM support"
@@ -106,11 +99,9 @@
 	  <http://www.tldp.org/docs.html#howto>. Also make sure to say
 	  Y or M to "ISO 9660 CD-ROM file system support" later.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called sr_mod. If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt> and
+	  To compile this driver as a module, say M here and read
 	  <file:Documentation/scsi/scsi.txt>.
+	  The module will be called sr_mod.
 
 config BLK_DEV_SR_VENDOR
 	bool "Enable vendor-specific extensions (for SCSI CDROM)"
@@ -141,10 +132,9 @@
 	  driver software yourself. Please read the file
 	  <file:Documentation/scsi/scsi-generic.txt> for more information.
 
-	  If you want to compile this as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt> and
+	  To compile this driver as a module, say M here and read
 	  <file:Documentation/scsi/scsi.txt>. The module will be called sg.
+
 	  If unsure, say N.
 
 comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
@@ -249,10 +239,8 @@
 	  family.  Some information is in the source:
 	  <file:drivers/scsi/wd7000.c>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called wd7000.  If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called wd7000.
 
 config SCSI_ACARD
 	tristate "ACARD SCSI support"
@@ -260,10 +248,8 @@
 	help
 	  This driver supports the ACARD 870U/W SCSI host adapter.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called atp870u. If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called atp870u.
 
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
@@ -277,10 +263,8 @@
 	  <http://www.tldp.org/docs.html#howto>. You might also want to
 	  read the file <file:Documentation/scsi/aha152x.txt>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called aha152x. If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called aha152x.
 
 config SCSI_AHA1542
 	tristate "Adaptec AHA1542 support"
@@ -293,10 +277,8 @@
 	  sold under the Adaptec name.  If it doesn't work out of the box, you
 	  may have to change some settings in <file:drivers/scsi/aha1542.h>.
 
-	  If you want to compile this as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called aha1542.
+	  To compile this driver as a module, say M here: the
+	  module will be called aha1542.
 
 config SCSI_AHA1740
 	tristate "Adaptec AHA1740 support"
@@ -308,10 +290,8 @@
 	  of the box, you may have to change some settings in
 	  <file:drivers/scsi/aha1740.h>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called aha1740.  If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called aha1740.
 
 config SCSI_AACRAID
 	tristate "Adaptec AACRAID support (EXPERIMENTAL)"
@@ -356,10 +336,8 @@
 	  available from <http://www.tldp.org/docs.html#howto>, can also
 	  be of great help.
 
-	  If you want to compile this driver as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called aic7xxx_old.
+	  To compile this driver as a module, say M here: the
+	  module will be called aic7xxx_old.
 
 source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
 
@@ -372,11 +350,8 @@
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
 	  driver by Deanna Bonds.  See <file:Documentation/scsi/dpti.txt>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  The module will be called
-	  dpt_i2o.
+	  To compile this driver as a module, say M here: the
+	  module will be called dpt_i2o.
 
 config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
@@ -386,11 +361,8 @@
 	  AdvanSys. It is documented in the kernel source in
 	  <file:drivers/scsi/advansys.c>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  The module will be called
-	  advansys.
+	  To compile this driver as a module, say M here: the
+	  module will be called advansys.
 
 config SCSI_IN2000
 	tristate "Always IN2000 SCSI support"
@@ -401,10 +373,8 @@
 	  out of the box, you may have to change the jumpers for IRQ or
 	  address selection.
 
-	  If you want to compile this as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called in2000.
+	  To compile this driver as a module, say M here: the
+	  module will be called in2000.
 
 # does not use pci dma and seems to be onboard only for old machines
 config SCSI_AM53C974
@@ -420,10 +390,8 @@
 	  "Tekram DC390(T) and Am53/79C974 (PCscsi) SCSI support", above.  You
 	  can pick either one.
 
-	  If you want to compile this driver as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called AM53C974.
+	  To compile this driver as a module, say M here: the
+	  module will be called AM53C974.
 
 config SCSI_MEGARAID
 	tristate "AMI MegaRAID support"
@@ -432,10 +400,8 @@
 	  This driver supports the AMI MegaRAID 418, 428, 438, 466, 762, 490
 	  and 467 SCSI host adapters.
 
-	  If you want to compile this driver as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called megaraid.
+	  To compile this driver as a module, say M here: the
+	  module will be called megaraid.
 
 config SCSI_BUSLOGIC
 	tristate "BusLogic SCSI support"
@@ -449,11 +415,8 @@
 	  driver does not work correctly without modification, please contact
 	  the author, Leonard N. Zubkoff, by email to lnz@dandelion.com.
 
-	  You can also build this driver as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  but only a single instance may be loaded. If you want to compile it
-	  as a module, say M here and read <file:Documentation/modules.txt>.
-	  The module will be called BusLogic.
+	  To compile this driver as a module, say M here: the
+	  module will be called BusLogic.
 
 config SCSI_OMIT_FLASHPOINT
 	bool "Omit FlashPoint support"
@@ -477,10 +440,8 @@
 	help
 	  This is support for Domex DMX3191D SCSI Host Adapters.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called dmx3191d.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called dmx3191d.
 
 config SCSI_DTC3280
 	tristate "DTC3180/3280 SCSI support"
@@ -491,10 +452,8 @@
 	  <http://www.tldp.org/docs.html#howto>, and the file
 	  <file:Documentation/scsi/dtc3x80.txt>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called dtc.  If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called dtc.
 
 config SCSI_EATA
 	tristate "EATA ISA/EISA/PCI (DPT and generic EATA/DMA-compliant boards) support"
@@ -509,10 +468,8 @@
 	  SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  If you want to compile this as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called eata.
+	  To compile this driver as a module, say M here: the
+	  module will be called eata.
 
 config SCSI_EATA_TAGGED_QUEUE
 	bool "enable tagged command queueing"
@@ -557,10 +514,8 @@
 	  numerous features.  You might want to have a look at the SCSI-HOWTO,
 	  available from <http://www.tldp.org/docs.html#howto>.
 
-	  If you want to compile this as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called eata_pio.
+	  To compile this driver as a module, say M here: the
+	  module will be called eata_pio.
 
 config SCSI_FUTURE_DOMAIN
 	tristate "Future Domain 16xx SCSI/AHA-2920A support"
@@ -578,10 +533,8 @@
 	  controller support"). This Future Domain driver works with the older
 	  Adaptec AHA-2920A boards with a Future Domain chip on them.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called fdomain. If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called fdomain.
 
 config SCSI_FD_MCS
 	tristate "Future Domain MCS-600/700 SCSI support"
@@ -593,10 +546,8 @@
 	  This driver also supports the Reply SB16/SCSI card (the SCSI part).
 	  It supports multiple adapters in the same system.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called fd_mcs. If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called fd_mcs.
 
 config SCSI_GDTH
 	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
@@ -609,10 +560,8 @@
 	  in the kernel source in <file:drivers/scsi/gdth.c> and
 	  <file:drivers/scsi/gdth.h.>
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called gdth.
 
 config SCSI_GENERIC_NCR5380
 	tristate "Generic NCR5380/53c400 SCSI PIO support"
@@ -630,10 +579,8 @@
 	  of the box, you may have to change some settings in
 	  <file:drivers/scsi/g_NCR5380.h>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called g_NCR5380.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called g_NCR5380.
 
 config SCSI_GENERIC_NCR5380_MMIO
 	tristate "Generic NCR5380/53c400 SCSI MMIO support"
@@ -646,11 +593,8 @@
 	  of the box, you may have to change some settings in
 	  <file:drivers/scsi/g_NCR5380.h>.
 
-	  This driver is also available as a module ( = code which can
-	  be inserted in and removed from the running kernel whenever
-	  you want).  The module will be called g_NCR5380_mmio.
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called g_NCR5380_mmio.
 
 config SCSI_GENERIC_NCR53C400
 	bool "Enable NCR53c400 extensions"
@@ -682,10 +626,8 @@
 	  bootparam" or see the documentation of your boot loader about how to
 	  pass options to the kernel.
 
-	  If you want to compile this driver as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called ibmmca.
+	  To compile this driver as a module, say M here: the
+	  module will be called ibmmca.
 
 config IBMMCA_SCSI_ORDER_STANDARD
 	bool "Standard SCSI-order"
@@ -745,11 +687,8 @@
 	  without modification please contact the author by email at
 	  ipslinux@adaptec.com.
 
-	  You can build this driver as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  but only a single instance may be loaded. If you want to compile it
-	  as a module, say M here and read <file:Documentation/modules.txt>.
-	  The module will be called ips.
+	  To compile this driver as a module, say M here: the
+	  module will be called ips.
 
 config SCSI_INITIO
 	tristate "Initio 9100U(W) support"
@@ -759,10 +698,8 @@
 	  read the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  If you want to compile this as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called initio.
+	  To compile this driver as a module, say M here: the
+	  module will be called initio.
 
 config SCSI_INIA100
 	tristate "Initio INI-A100U2W support"
@@ -772,10 +709,8 @@
 	  Please read the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  If you want to compile this as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called a100u2w.
+	  To compile this driver as a module, say M here: the
+	  module will be called a100u2w.
 
 config SCSI_PPA
 	tristate "IOMEGA parallel port (ppa - older drives)"
@@ -801,10 +736,8 @@
 	  such as a printer; it is safe to compile both drivers into the
 	  kernel.
 
-	  This driver is also available as a module which can be inserted in
-	  and removed from the running kernel whenever you want.  To compile
-	  this driver as a module, say M here and read
-	  <file:Documentation/modules.txt>.  The module will be called ppa.
+	  To compile this driver as a module, say M here: the
+	  module will be called ppa.
 
 config SCSI_IMM
 	tristate "IOMEGA parallel port (imm - newer drives)"
@@ -830,10 +763,8 @@
 	  such as a printer; it is safe to compile both drivers into the
 	  kernel.
 
-	  This driver is also available as a module which can be inserted in
-	  and removed from the running kernel whenever you want.  To compile
-	  this driver as a module, say M here and read
-	  <file:Documentation/modules.txt>.  The module will be called imm.
+	  To compile this driver as a module, say M here: the
+	  module will be called imm.
 
 config SCSI_IZIP_EPP16
 	bool "ppa/imm option - Use slow (but safe) EPP-16"
@@ -873,10 +804,8 @@
 	  in the kernel source.  Also read the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  If you want to compile this driver as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called NCR53c406.
+	  To compile this driver as a module, say M here: the
+	  module will be called NCR53c406.
 
 config SCSI_NCR_D700
 	tristate "NCR Dual 700 MCA SCSI support"
@@ -1106,10 +1035,8 @@
 	  controller based on the NCR 53C94.  This driver will allow use of
 	  the controller on the 3550, and very possibly others.
 
-	  If you want to compile this as a module (= code which can be
-	  inserted and removed from the running kernel whenever you want), say
-	  M here and read <file:Documentation/modules.txt>.  The module will
-	  be called mca_53c9x.
+	  To compile this driver as a module, say M here: the
+	  module will be called mca_53c9x.
 
 config SCSI_PAS16
 	tristate "PAS16 SCSI support"
@@ -1121,10 +1048,8 @@
 	  of the box, you may have to change some settings in
 	  <file:drivers/scsi/pas16.h>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called pas16.  If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called pas16.
 
 config SCSI_PCI2000
 	tristate "PCI2000 support"
@@ -1134,10 +1059,8 @@
 	  SCSI host adapter.  Please read the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  This driver is also available as a module called pci2000 ( = code
-	  which can be inserted in and removed from the running kernel
-	  whenever you want).  If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called pci2000.
 
 config SCSI_PCI2220I
 	tristate "PCI2220i support"
@@ -1147,10 +1070,8 @@
 	  SCSI host adapter.  Please read the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  This driver is also available as a module called pci2220i ( = code
-	  which can be inserted in and removed from the running kernel
-	  whenever you want).  If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called pci2220i.
 
 config SCSI_PSI240I
 	tristate "PSI240i support"
@@ -1160,10 +1081,8 @@
 	  SCSI host adapter.  Please read the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  This driver is also available as a module called psi240i ( = code
-	  which can be inserted in and removed from the running kernel
-	  whenever you want).  If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called psi240i.
 
 config SCSI_QLOGIC_FAS
 	tristate "Qlogic FAS SCSI support"
@@ -1182,10 +1101,8 @@
 	  SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called qlogicfas. If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called qlogicfas.
 
 config SCSI_QLOGIC_ISP
 	tristate "Qlogic ISP SCSI support"
@@ -1202,10 +1119,8 @@
 	  should also read the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called qlogicisp.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called qlogicisp.
 
 config SCSI_QLOGIC_FC
 	tristate "Qlogic ISP FC SCSI support"
@@ -1213,10 +1128,8 @@
 	help
 	  This is a driver for the QLogic ISP2100 SCSI-FCP host adapter.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called qlogicfc.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called qlogicfc.
 
 config SCSI_QLOGIC_FC_FIRMWARE
 	bool "Include loadable firmware in driver"
@@ -1232,10 +1145,8 @@
 	help
 	  Say Y if you have a QLogic ISP1x80/1x160 SCSI host adapter.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called qla1280. If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called qla1280.
 
 config SCSI_QLOGIC_1280_PIO
 	bool "Use PIO instead of MMIO" if !X86_VISWS
@@ -1256,10 +1167,8 @@
 	  PTI,ptisp or QLGC,isp. Note that PCI QLogic SCSI controllers are
 	  driven by a different driver.
 
-	  This support is also available as a module called qlogicpti ( =
-	  code which can be inserted in and removed from the running kernel
-	  whenever you want). If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called qlogicpti.
 
 config SCSI_SEAGATE
 	tristate "Seagate ST-02 and Future Domain TMC-8xx SCSI support"
@@ -1271,10 +1180,8 @@
 	  doesn't work out of the box, you may have to change some settings in
 	  <file:drivers/scsi/seagate.h>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called seagate.  If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called seagate.
 
 # definitely looks not 64bit safe:
 config SCSI_SIM710
@@ -1305,11 +1212,8 @@
 
 	  insmod sym53c416 sym53c416=<base>,<irq> [sym53c416_1=<base>,<irq>]
 
-	  There is support for up to four adapters. If you want to compile
-	  this driver as a module ( = code which can be inserted in and
-	  removed from the running kernel whenever you want), say M here and
-	  read <file:Documentation/modules.txt>. The module will be called
-	  sym53c416.
+	  To compile this driver as a module, say M here: the
+	  module will be called sym53c416.
 
 config SCSI_DC395x
 	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support (EXPERIMENTAL)"
@@ -1323,10 +1227,8 @@
 
 	  Documentation can be found in <file:Documentation/scsi/dc395x.txt>.
 
-	  If you want to compile this driver as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called dc395x.
+	  To compile this driver as a module, say M here: the
+	  module will be called dc395x.
 
 config SCSI_DC390T
 	tristate "Tekram DC390(T) and Am53/79C974 SCSI support"
@@ -1343,10 +1245,8 @@
 	  Also note that there is another generic Am53C974 driver,
 	  "AM53/79C974 PCI SCSI support" below.  You can pick either one.
 
-	  If you want to compile this driver as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called tmscsim.
+	  To compile this driver as a module, say M here: the
+	  module will be called tmscsim.
 
 config SCSI_DC390T_NOGENSUPP
 	bool "_omit_ support for non-DC390 adapters"
@@ -1377,10 +1277,8 @@
 	  Adaptec, and some former Trantor products are being sold under the
 	  Adaptec name.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called t128.  If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called t128.
 
 config SCSI_U14_34F
 	tristate "UltraStor 14F/34F support"
@@ -1396,10 +1294,8 @@
 	  below.  You should say Y to both only if you want 24F support as
 	  well.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called u14-34f.  If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called u14-34f.
 
 config SCSI_U14_34F_TAGGED_QUEUE
 	bool "enable tagged command queueing"
@@ -1447,10 +1343,8 @@
 	  Note that there is also another driver for the same hardware:
 	  "UltraStor 14F/34F support", above.
 
-	  If you want to compile this as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called ultrastor.
+	  To compile this driver as a module, say M here: the
+	  module will be called ultrastor.
 
 config SCSI_NSP32
 	tristate "Workbit NinjaSCSI-32Bi/UDE support"
@@ -1460,10 +1354,8 @@
 	  SCSI host adapter. Please read the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  If you want to compile this as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called nsp32.
+	  To compile this driver as a module, say M here: the
+	  module will be called nsp32.
 
 config SCSI_DEBUG
 	tristate "SCSI debugging host simulator"
@@ -1485,10 +1377,10 @@
 	  Many Power Macintoshes and clones have a MESH (Macintosh Enhanced
 	  SCSI Hardware) SCSI bus adaptor (the 7200 doesn't, but all of the
 	  other Power Macintoshes do). Say Y to include support for this SCSI
-	  adaptor. This driver is also available as a module called mesh
-	  ( = code which can be inserted in and removed from the running
-	  kernel whenever you want). If you want to compile it as a module,
-	  say M here and read <file:Documentation/modules.txt>.
+	  adaptor.
+
+	  To compile this driver as a module, say M here: the
+	  module will be called mesh.
 
 config SCSI_MESH_SYNC_RATE
 	int "maximum synchronous transfer rate (MB/s) (0 = async)"
@@ -1518,10 +1410,8 @@
 	  machines which only have one SCSI bus, such as the 7200, also use
 	  the 53C94. Say Y to include support for the 53C94.
 
-	  This driver is also available as a module called mac53c94 ( = code
-	  which can be inserted in and removed from the running kernel
-	  whenever you want). If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called mac53c94.
 
 source "drivers/scsi/arm/Kconfig"
 
@@ -1538,11 +1428,10 @@
 	depends on AMIGA && SCSI
 	help
 	  If you have an Amiga 3000 and have SCSI devices connected to the
-	  built-in SCSI controller, say Y. Otherwise, say N. This driver is
-	  also available as a module ( = code which can be inserted in and
-	  removed from the running kernel whenever you want). The module is
-	  called wd33c93. If you want to compile it as a module, say M here
-	  and read <file:Documentation/modules.txt>.
+	  built-in SCSI controller, say Y. Otherwise, say N.
+
+	  To compile this driver as a module, say M here: the
+	  module will be called wd33c93.
 
 config A4000T_SCSI
 	bool "A4000T SCSI support (EXPERIMENTAL)"
@@ -1555,10 +1444,10 @@
 	depends on ZORRO && SCSI
 	help
 	  If you have a Commodore A2091 SCSI controller, say Y. Otherwise,
-	  say N. This driver is also available as a module ( = code which can
-	  be inserted in and removed from the running kernel whenever you
-	  want). The module is called wd33c93. If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
+	  say N.
+
+	  To compile this driver as a module, say M here: the
+	  module will be called wd33c93.
 
 config GVP11_SCSI
 	tristate "GVP Series II WD33C93A support"
@@ -1570,10 +1459,8 @@
 	  answer N. This driver does NOT work for the T-Rex series of
 	  accelerators from TekMagic and GVP-M.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you
-	  want). The module will be called gvp11. If you want to compile it
-	  as a module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called gvp11.
 
 config CYBERSTORM_SCSI
 	tristate "CyberStorm SCSI support"
@@ -1652,14 +1539,15 @@
 	---help---
 	  If you have an Atari with built-in NCR5380 SCSI controller (TT,
 	  Falcon, ...) say Y to get it supported. Of course also, if you have
-	  a compatible SCSI controller (e.g. for Medusa).  This driver is also
-	  available as a module ( = code which can be inserted in and removed
-	  from the running kernel whenever you want).  The module is called
-	  atari_scsi.  If you want to compile it as a module, say M here and
-	  read <file:Documentation/modules.txt>.  This driver supports both
-	  styles of NCR integration into the system: the TT style (separate
-	  DMA), and the Falcon style (via ST-DMA, replacing ACSI).  It does
-	  NOT support other schemes, like in the Hades (without DMA).
+	  a compatible SCSI controller (e.g. for Medusa).
+
+	  To compile this driver as a module, say M here: the
+	  module will be called atari_scsi.
+
+	  This driver supports both styles of NCR integration into the
+	  system: the TT style (separate DMA), and the Falcon style (via
+	  ST-DMA, replacing ACSI).  It does NOT support other schemes, like
+	  in the Hades (without DMA).
 
 config ATARI_SCSI_TOSHIBA_DELAY
 	bool "Long delays for Toshiba CD-ROMs"
@@ -1704,10 +1592,8 @@
 	  SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called mac_esp.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called mac_esp.
 
 config MVME147_SCSI
 	bool "WD33C93 SCSI driver for MVME147"
@@ -1764,10 +1650,8 @@
 	  This is the driver for the Sun ESP SCSI host adapter. The ESP
 	  chipset is present in most SPARC SBUS-based computers.
 
-	  This support is also available as a module called esp ( = code
-	  which can be inserted in and removed from the running kernel
-	  whenever you want). If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
+	  To compile this driver as a module, say M here: the
+	  module will be called esp.
 
 config SCSI_PC980155
 	tristate "NEC PC-9801-55 SCSI support"
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: Nicolas Kaiser <nikai@nikai.net>: Re: [PATCH] Remove modules.txt drivers_scsi_Kconfig II
