From: Rolf Eike Beer <eike@bilbo.math.uni-mannheim.de>
Subject: [PATCH 1/2] clean up scsi documentation
Date: Mon, 11 Nov 2002 16:45:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211111645.55685@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Ok, here comes part 2. Not mentioned in the first mail: it makes some minor
formatting changes in some comments.

Eike

diff -Naur linux-2.5.47-scsi-doc-moved/Documentation/00-INDEX linux-2.5.47-scsi-doc/Documentation/00-INDEX
--- linux-2.5.47-scsi-doc-moved/Documentation/00-INDEX	Mon Nov 11 08:17:20 2002
+++ linux-2.5.47-scsi-doc/Documentation/00-INDEX	Mon Nov 11 08:32:33 2002
@@ -32,8 +32,6 @@
 	- info on Mylex DAC960/DAC1100 PCI RAID Controller Driver for Linux
 README.moxa
 	- release notes for Moxa mutiport serial card.
-README.nsp_cs.eng
-	- info on WorkBiT NinjaSCSI-3/32Bi driver.
 SAK.txt
 	- info on Secure Attention Keys.
 SubmittingDrivers
@@ -188,10 +186,8 @@
 	- directory with info on using Linux on the IBM S390.
 sh/
 	- directory with info on porting Linux to a new architecture.
-scsi-generic.txt
-	- info on the sg driver for generic (non-disk/CD/tape) SCSI devices.
-scsi.txt
-	- short blurb on using SCSI support as a module.
+scsi/
+	- directory with info on Linux scsi support.
 serial-console.txt
 	- how to set up Linux with a serial line console as the default.
 sgi-visws.txt
diff -Naur linux-2.5.47-scsi-doc-moved/Documentation/scsi/00-INDEX linux-2.5.47-scsi-doc/Documentation/scsi/00-INDEX
--- linux-2.5.47-scsi-doc-moved/Documentation/scsi/00-INDEX	Thu Jan  1 01:00:00 1970
+++ linux-2.5.47-scsi-doc/Documentation/scsi/00-INDEX	Mon Nov 11 08:32:33 2002
@@ -0,0 +1,68 @@
+00-INDEX
+	- this file
+53c700.txt
+	- info on driver for 53c700 based adapters
+AM53C974.txt
+	- info on driver for AM53c974 based adapters
+BusLogic.txt
+	- info on driver for adapters with BusLogic chips
+ChangeLog
+	- Changes to scsi files, if not listed elsewhere
+ChangeLog.ips
+	- IBM ServeRAID driver Changelog
+ChangeLog.ncr53c8xx
+	- Changes to ncr53c8xx driver
+ChangeLog.sym53c8xx
+	- Changes to sym53c8xx driver
+ChangeLog.sym53c8xx_2
+	- Changes to second generation of sym53c8xx driver
+FlashPoint.txt
+	- info on driver for BusLogic FlashPoint adapters
+LICENSE.FlashPoint
+	- Licence of the Flashpoint driver
+Mylex.txt
+	- info on driver for Mylex adapters
+NinjaSCSI.txt
+	- info on WorkBiT NinjaSCSI-32/32Bi driver
+aha152x.txt
+	- info on driver for Adaptec AHA152x based adapters
+aic7xxx.txt
+	- info on driver for Adaptec controllers
+aic7xxx_old.txt
+	- info on driver for Adaptec controllers, old generation
+cpqfc.txt
+	- info on driver for Compaq Tachyon TS adapters
+dpti.txt
+	- info on driver for DPT SmartRAID and Adaptec I2O RAID based adapters
+dtc3x80.txt
+	- info on driver for DTC 2x80 based adapters
+g_NCR5380.txt
+	- info on driver for NCR5380 and NCR53c400 based adapters
+ibmmca.txt
+	- info on driver for IBM adapters with MCA bus
+in2000.txt
+	- info on in2000 driver
+ncr53c7xx.txt
+	- info on driver for NCR53c7xx based adapters
+ncr53c8xx.txt
+	- info on driver for NCR53c8xx based adapters
+osst.txt
+	- info on driver for OnStream SC-x0 SCSI tape
+ppa.txt
+	- info on driver for IOmega zip drive
+qlogicfas.txt
+	- info on driver for QLogic FASxxx based adapters
+qlogicisp.txt
+	- info on driver for QLogic ISP 1020 based adapters
+scsi-generic.txt
+	- info on the sg driver for generic (non-disk/CD/tape) SCSI devices.
+scsi.txt
+	- short blurb on using SCSI support as a module.
+scsi_mid_low_api.txt
+	- info on API between SCSI layer and low level drivers
+st.txt
+	- info on scsi tape driver
+sym53c8xx_2.txt
+	- info on second generation driver for sym53c8xx based adapters
+tmscsim.txt
+	- info on driver for AM53c974 based adapters
diff -Naur linux-2.5.47-scsi-doc-moved/arch/alpha/Kconfig linux-2.5.47-scsi-doc/arch/alpha/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/alpha/Kconfig	Mon Nov 11 08:17:01 2002
+++ linux-2.5.47-scsi-doc/arch/alpha/Kconfig	Mon Nov 11 08:32:33 2002
@@ -794,7 +794,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/arm/Kconfig linux-2.5.47-scsi-doc/arch/arm/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/arm/Kconfig	Mon Nov 11 08:17:05 2002
+++ linux-2.5.47-scsi-doc/arch/arm/Kconfig	Mon Nov 11 08:32:33 2002
@@ -1014,7 +1014,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/cris/Kconfig linux-2.5.47-scsi-doc/arch/cris/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/cris/Kconfig	Mon Nov 11 08:17:01 2002
+++ linux-2.5.47-scsi-doc/arch/cris/Kconfig	Mon Nov 11 08:32:33 2002
@@ -589,7 +589,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/i386/Kconfig linux-2.5.47-scsi-doc/arch/i386/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/i386/Kconfig	Mon Nov 11 08:17:00 2002
+++ linux-2.5.47-scsi-doc/arch/i386/Kconfig	Mon Nov 11 08:32:33 2002
@@ -1298,7 +1298,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/ia64/Kconfig linux-2.5.47-scsi-doc/arch/ia64/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/ia64/Kconfig	Mon Nov 11 08:17:06 2002
+++ linux-2.5.47-scsi-doc/arch/ia64/Kconfig	Mon Nov 11 08:32:33 2002
@@ -601,7 +601,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/m68k/Kconfig linux-2.5.47-scsi-doc/arch/m68k/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/m68k/Kconfig	Mon Nov 11 08:17:01 2002
+++ linux-2.5.47-scsi-doc/arch/m68k/Kconfig	Mon Nov 11 08:32:33 2002
@@ -731,7 +731,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
@@ -752,7 +752,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called sd_mod.o.  If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  Do not compile this driver as a
+	  <file:Documentation/scsi/scsi.txt>.  Do not compile this driver as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI disk. In this case, do not compile the driver
 	  for your SCSI host adapter (below) as a module either.
@@ -781,14 +781,14 @@
 	  If you want to use a SCSI tape drive under Linux, say Y and read the
 	  SCSI-HOWTO, available from
 	  <http://www.linuxdoc.org/docs.html#howto>, and
-	  <file:drivers/scsi/README.st> in the kernel source.  This is NOT for
+	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT for
 	  SCSI CD-ROMs.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called st.o. If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.
+	  <file:Documentation/scsi/scsi.txt>.
 
 config ST_EXTRA_DEVS
 	int "Maximum number of SCSI tapes that can be loaded as modules"
@@ -820,7 +820,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called sr_mod.o. If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.
+	  <file:Documentation/scsi/scsi.txt>.
 
 config BLK_DEV_SR_VENDOR
 	bool "Enable vendor-specific extensions (for SCSI CDROM)"
@@ -866,13 +866,13 @@
 	  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/>).
 	  For other devices, it's possible that you'll have to write the
 	  driver software yourself. Please read the file
-	  <file:Documentation/scsi-generic.txt> for more information.
+	  <file:Documentation/scsi/scsi-generic.txt> for more information.
 
 	  If you want to compile this as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>. The module will be called sg.o. If unsure,
-	  say N.
+	  <file:Documentation/scsi/scsi.txt>. The module will be called sg.o.
+	  If unsure, say N.
 
 comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
 	depends on SCSI
diff -Naur linux-2.5.47-scsi-doc-moved/arch/mips/Kconfig linux-2.5.47-scsi-doc/arch/mips/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/mips/Kconfig	Mon Nov 11 08:17:02 2002
+++ linux-2.5.47-scsi-doc/arch/mips/Kconfig	Mon Nov 11 08:32:33 2002
@@ -904,7 +904,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/mips64/Kconfig linux-2.5.47-scsi-doc/arch/mips64/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/mips64/Kconfig	Mon Nov 11 08:17:06 2002
+++ linux-2.5.47-scsi-doc/arch/mips64/Kconfig	Mon Nov 11 08:32:33 2002
@@ -488,7 +488,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/parisc/Kconfig linux-2.5.47-scsi-doc/arch/parisc/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/parisc/Kconfig	Mon Nov 11 08:17:05 2002
+++ linux-2.5.47-scsi-doc/arch/parisc/Kconfig	Mon Nov 11 08:32:33 2002
@@ -257,7 +257,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/ppc/Kconfig linux-2.5.47-scsi-doc/arch/ppc/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/ppc/Kconfig	Mon Nov 11 08:17:00 2002
+++ linux-2.5.47-scsi-doc/arch/ppc/Kconfig	Mon Nov 11 08:32:33 2002
@@ -1393,7 +1393,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/ppc64/Kconfig linux-2.5.47-scsi-doc/arch/ppc64/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/ppc64/Kconfig	Mon Nov 11 08:17:02 2002
+++ linux-2.5.47-scsi-doc/arch/ppc64/Kconfig	Mon Nov 11 08:32:33 2002
@@ -332,7 +332,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/sh/Kconfig linux-2.5.47-scsi-doc/arch/sh/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/sh/Kconfig	Mon Nov 11 08:17:07 2002
+++ linux-2.5.47-scsi-doc/arch/sh/Kconfig	Mon Nov 11 08:32:33 2002
@@ -733,7 +733,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/sparc/Kconfig linux-2.5.47-scsi-doc/arch/sparc/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/sparc/Kconfig	Mon Nov 11 08:16:57 2002
+++ linux-2.5.47-scsi-doc/arch/sparc/Kconfig	Mon Nov 11 08:32:33 2002
@@ -662,7 +662,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
@@ -683,7 +683,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called sd_mod.o.  If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  Do not compile this driver as a
+	  <file:Documentation/scsi/scsi.txt>.  Do not compile this driver as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI disk. In this case, do not compile the driver
 	  for your SCSI host adapter (below) as a module either.
@@ -712,14 +712,14 @@
 	  If you want to use a SCSI tape drive under Linux, say Y and read the
 	  SCSI-HOWTO, available from
 	  <http://www.linuxdoc.org/docs.html#howto>, and
-	  <file:drivers/scsi/README.st> in the kernel source.  This is NOT for
-	  SCSI CD-ROMs.
+	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT
+	  for SCSI CD-ROMs.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called st.o. If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.
+	  <file:Documentation/scsi/scsi.txt>.
 
 config CHR_DEV_OSST
 	tristate "SCSI OnStream SC-x0 tape support"
@@ -734,7 +734,7 @@
 	  tapes (QIC-157) and can be driven by the standard driver st.
 	  For more information, you may have a look at the SCSI-HOWTO
 	  <http://www.linuxdoc.org/docs.html#howto>  and
-	  <file:drivers/scsi/README.osst>  in the kernel source.
+	  <file:Documentation/scsi/osst.txt>  in the kernel source.
 	  More info on the OnStream driver may be found on
 	  <http://linux1.onstream.nl/test/>
 	  Please also have a look at the standard st docu, as most of it
@@ -744,7 +744,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called osst.o. If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.
+	  <file:Documentation/scsi/scsi.txt>.
 
 config BLK_DEV_SR
 	tristate "SCSI CDROM support"
@@ -759,7 +759,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called sr_mod.o. If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.
+	  <file:Documentation/scsi/scsi.txt>.
 
 config BLK_DEV_SR_VENDOR
 	bool "Enable vendor-specific extensions (for SCSI CDROM)"
@@ -805,13 +805,13 @@
 	  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/>).
 	  For other devices, it's possible that you'll have to write the
 	  driver software yourself. Please read the file
-	  <file:Documentation/scsi-generic.txt> for more information.
+	  <file:Documentation/scsi/scsi-generic.txt> for more information.
 
 	  If you want to compile this as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>. The module will be called sg.o. If unsure,
-	  say N.
+	  <file:Documentation/scsi/scsi.txt>. The module will be called sg.o.
+	  If unsure, say N.
 
 comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
 	depends on SCSI
diff -Naur linux-2.5.47-scsi-doc-moved/arch/sparc64/Kconfig linux-2.5.47-scsi-doc/arch/sparc64/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/sparc64/Kconfig	Mon Nov 11 08:17:01 2002
+++ linux-2.5.47-scsi-doc/arch/sparc64/Kconfig	Mon Nov 11 08:32:33 2002
@@ -757,7 +757,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
@@ -778,7 +778,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called sd_mod.o.  If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  Do not compile this driver as a
+	  <file:Documentation/scsi/scsi.txt>.  Do not compile this driver as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI disk. In this case, do not compile the driver
 	  for your SCSI host adapter (below) as a module either.
@@ -807,14 +807,14 @@
 	  If you want to use a SCSI tape drive under Linux, say Y and read the
 	  SCSI-HOWTO, available from
 	  <http://www.linuxdoc.org/docs.html#howto>, and
-	  <file:drivers/scsi/README.st> in the kernel source.  This is NOT for
-	  SCSI CD-ROMs.
+	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT
+	  for SCSI CD-ROMs.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called st.o. If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.
+	  <file:Documentation/scsi/scsi.txt>.
 
 config CHR_DEV_OSST
 	tristate "SCSI OnStream SC-x0 tape support"
@@ -829,7 +829,7 @@
 	  tapes (QIC-157) and can be driven by the standard driver st.
 	  For more information, you may have a look at the SCSI-HOWTO
 	  <http://www.linuxdoc.org/docs.html#howto>  and
-	  <file:drivers/scsi/README.osst>  in the kernel source.
+	  <file:Documentation/scsi/osst.txt>  in the kernel source.
 	  More info on the OnStream driver may be found on
 	  <http://linux1.onstream.nl/test/>
 	  Please also have a look at the standard st docu, as most of it
@@ -839,7 +839,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called osst.o. If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.
+	  <file:Documentation/scsi/scsi.txt>.
 
 config BLK_DEV_SR
 	tristate "SCSI CDROM support"
@@ -854,7 +854,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called sr_mod.o. If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.
+	  <file:Documentation/scsi/scsi.txt>.
 
 config BLK_DEV_SR_VENDOR
 	bool "Enable vendor-specific extensions (for SCSI CDROM)"
@@ -900,13 +900,13 @@
 	  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/>).
 	  For other devices, it's possible that you'll have to write the
 	  driver software yourself. Please read the file
-	  <file:Documentation/scsi-generic.txt> for more information.
+	  <file:Documentation/scsi/scsi-generic.txt> for more information.
 
 	  If you want to compile this as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>. The module will be called sg.o. If unsure,
-	  say N.
+	  <file:Documentation/scsi/scsi.txt>. The module will be called sg.o.
+	  If unsure, say N.
 
 comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
 	depends on SCSI
@@ -1025,7 +1025,7 @@
 	  Information on the configuration options for this controller can be
 	  found by checking the help file for each of the available
 	  configuration options. You should read
-	  <file:drivers/scsi/aic7xxx_old/README.aic7xxx> at a minimum before
+	  <file:Documentation/scsi/aic7xxx_old.txt> at a minimum before
 	  contacting the maintainer with any questions.  The SCSI-HOWTO,
 	  available from <http://www.linuxdoc.org/docs.html#howto>, can also
 	  be of great help.
@@ -1051,7 +1051,7 @@
 
 	  If you say Y here, you can still turn off TCQ on troublesome devices
 	  with the use of the tag_info boot parameter.  See the file
-	  <file:drivers/scsi/README.aic7xxx> for more information on that and
+	  <file:Documentation/scsi/aic7xxx.txt> for more information on that and
 	  other aic7xxx setup commands.  If this option is turned off, you may
 	  still enable TCQ on known good devices by use of the tag_info boot
 	  parameter.
@@ -1061,7 +1061,7 @@
 
 	  However, TCQ can increase performance on some hard drives by as much
 	  as 50% or more, so it is recommended that if you say N here, you
-	  should at least read the <file:drivers/scsi/README.aic7xxx> file so
+	  should at least read the <file:Documentation/scsi/aic7xxx.txt> file so
 	  you will know how to enable this option manually should your drives
 	  prove to be safe in regards to TCQ.
 
@@ -1200,7 +1200,7 @@
 	  only one may be active at a time.  If you have a 53c8xx board, you
 	  probably do not want to use the "NCR53c7,8xx SCSI support".
 
-	  Please read <file:drivers/scsi/README.ncr53c8xx> for more
+	  Please read <file:Documentation/scsi/ncr53c8xx.txt> for more
 	  information.
 
 config SCSI_SYM53C8XX
@@ -1227,7 +1227,7 @@
 	  SYM53C8XX driver, thus allowing the NCR53C8XX driver to attach them.
 	  The 'excl' option is also supported by the NCR53C8XX driver.
 
-	  Please read <file:drivers/scsi/README.ncr53c8xx> for more
+	  Please read <file:Documentation/scsi/ncr53c8xx.txt> for more
 	  information.
 
 config SCSI_NCR53C8XX_DEFAULT_TAGS
@@ -1371,7 +1371,7 @@
 	  If you say Y here, make sure to choose "BIOS" at the question "PCI
 	  access mode".
 
-	  Please read the file <file:drivers/scsi/README.qlogicisp>.  You
+	  Please read the file <file:Documentation/scsi/qlogicisp.txt>.  You
 	  should also read the SCSI-HOWTO, available from
 	  <http://www.linuxdoc.org/docs.html#howto>.
 
diff -Naur linux-2.5.47-scsi-doc-moved/arch/x86_64/Kconfig linux-2.5.47-scsi-doc/arch/x86_64/Kconfig
--- linux-2.5.47-scsi-doc-moved/arch/x86_64/Kconfig	Mon Nov 11 08:17:02 2002
+++ linux-2.5.47-scsi-doc/arch/x86_64/Kconfig	Mon Nov 11 08:32:33 2002
@@ -505,7 +505,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called scsi_mod.o.  If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  However, do not compile this as a
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/Kconfig linux-2.5.47-scsi-doc/drivers/scsi/Kconfig
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/Kconfig	Mon Nov 11 08:16:52 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/Kconfig	Mon Nov 11 08:32:33 2002
@@ -15,7 +15,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called sd_mod.o.  If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.  Do not compile this driver as a
+	  <file:Documentation/scsi/scsi.txt>.  Do not compile this driver as a
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI disk. In this case, do not compile the driver
 	  for your SCSI host adapter (below) as a module either.
@@ -27,14 +27,14 @@
 	  If you want to use a SCSI tape drive under Linux, say Y and read the
 	  SCSI-HOWTO, available from
 	  <http://www.linuxdoc.org/docs.html#howto>, and
-	  <file:drivers/scsi/README.st> in the kernel source.  This is NOT for
+	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT for
 	  SCSI CD-ROMs.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called st.o. If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.
+	  <file:Documentation/scsi/scsi.txt>.
 
 config CHR_DEV_OSST
 	tristate "SCSI OnStream SC-x0 tape support"
@@ -49,7 +49,7 @@
 	  tapes (QIC-157) and can be driven by the standard driver st.
 	  For more information, you may have a look at the SCSI-HOWTO
 	  <http://www.linuxdoc.org/docs.html#howto>  and
-	  <file:drivers/scsi/README.osst>  in the kernel source.
+	  <file:Documentation/scsi/osst.txt>  in the kernel source.
 	  More info on the OnStream driver may be found on
 	  <http://linux1.onstream.nl/test/>
 	  Please also have a look at the standard st docu, as most of it
@@ -59,7 +59,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called osst.o. If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.
+	  <file:Documentation/scsi/scsi.txt>.
 
 config BLK_DEV_SR
 	tristate "SCSI CDROM support"
@@ -74,7 +74,7 @@
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called sr_mod.o. If you want to compile it as a
 	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>.
+	  <file:Documentation/scsi/scsi.txt>.
 
 config BLK_DEV_SR_VENDOR
 	bool "Enable vendor-specific extensions (for SCSI CDROM)"
@@ -103,13 +103,13 @@
 	  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/>).
 	  For other devices, it's possible that you'll have to write the
 	  driver software yourself. Please read the file
-	  <file:Documentation/scsi-generic.txt> for more information.
+	  <file:Documentation/scsi/scsi-generic.txt> for more information.
 
 	  If you want to compile this as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi.txt>. The module will be called sg.o. If unsure,
-	  say N.
+	  <file:Documentation/scsi/scsi.txt>. The module will be called sg.o.
+	  If unsure, say N.
 
 comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
 	depends on SCSI
@@ -235,7 +235,7 @@
 
 	  It is explained in section 3.3 of the SCSI-HOWTO, available from
 	  <http://www.linuxdoc.org/docs.html#howto>. You might also want to
-	  read the file <file:drivers/scsi/README.aha152x>.
+	  read the file <file:Documentation/scsi/aha152x.txt>.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
@@ -315,7 +315,7 @@
 	  Information on the configuration options for this controller can be
 	  found by checking the help file for each of the available
 	  configuration options. You should read
-	  <file:drivers/scsi/aic7xxx_old/README.aic7xxx> at a minimum before
+	  <file:Documentation/scsi/aic7xxx_old.txt> at a minimum before
 	  contacting the maintainer with any questions.  The SCSI-HOWTO,
 	  available from <http://www.linuxdoc.org/docs.html#howto>, can also
 	  be of great help.
@@ -335,7 +335,7 @@
 	help
 	  This driver supports all of Adaptec's I2O based RAID controllers as 
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
-	  driver by Deanna Bonds.  See <file:drivers/scsi/README.dpti>.
+	  driver by Deanna Bonds.  See <file:Documentation/scsi/dpti.txt>.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
@@ -362,7 +362,7 @@
 	depends on SCSI
 	help
 	  This is support for an ISA bus SCSI host adapter.  You'll find more
-	  information in <file:drivers/scsi/README.in2000>. If it doesn't work
+	  information in <file:Documentation/scsi/in2000.txt>. If it doesn't work
 	  out of the box, you may have to change the jumpers for IRQ or
 	  address selection.
 
@@ -377,7 +377,7 @@
 	depends on !X86_64 && SCSI && PCI
 	---help---
 	  This is support for the AM53/79C974 SCSI host adapters.  Please read
-	  <file:drivers/scsi/README.AM53C974> for details.  Also, the
+	  <file:Documentation/scsi/AM53C974.txt> for details.  Also, the
 	  SCSI-HOWTO, available from
 	  <http://www.linuxdoc.org/docs.html#howto>, is for you.
 
@@ -409,8 +409,8 @@
 	  This is support for BusLogic MultiMaster and FlashPoint SCSI Host
 	  Adapters. Consult the SCSI-HOWTO, available from
 	  <http://www.linuxdoc.org/docs.html#howto>, and the files
-	  <file:drivers/scsi/README.BusLogic> and
-	  <file:drivers/scsi/README.FlashPoint> for more information. If this
+	  <file:Documentation/scsi/BusLogic.txt> and
+	  <file:Documentation/scsi/FlashPoint.txt> for more information. If this
 	  driver does not work correctly without modification, please contact
 	  the author, Leonard N. Zubkoff, by email to lnz@dandelion.com.
 
@@ -454,7 +454,7 @@
 	  This is support for DTC 3180/3280 SCSI Host Adapters.  Please read
 	  the SCSI-HOWTO, available from
 	  <http://www.linuxdoc.org/docs.html#howto>, and the file
-	  <file:drivers/scsi/README.dtc3x80>.
+	  <file:Documentation/scsi/dtc3x80.txt>.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
@@ -648,7 +648,7 @@
 	  for the Trantor T130B in its default configuration; you might have
 	  to pass a command line option to the kernel at boot time if it does
 	  not detect your card.  See the file
-	  <file:drivers/scsi/README.g_NCR5380> for details.
+	  <file:Documentation/scsi/g_NCR5380.txt> for details.
 
 config SCSI_IBMMCA
 	tristate "IBMMCA SCSI support"
@@ -781,7 +781,7 @@
 	  newer drives)", below.
 
 	  For more information about this driver and how to use it you should
-	  read the file <file:drivers/scsi/README.ppa>.  You should also read
+	  read the file <file:Documentation/scsi/ppa.txt>.  You should also read
 	  the SCSI-HOWTO, which is available from
 	  <http://www.linuxdoc.org/docs.html#howto>.  If you use this driver,
 	  you will still be able to use the parallel port for other tasks,
@@ -810,7 +810,7 @@
 	  here and Y to "IOMEGA Parallel Port (ppa - older drives)", above.
 
 	  For more information about this driver and how to use it you should
-	  read the file <file:drivers/scsi/README.ppa>.  You should also read
+	  read the file <file:Documentation/scsi/ppa.txt>.  You should also read
 	  the SCSI-HOWTO, which is available from
 	  <http://www.linuxdoc.org/docs.html#howto>.  If you use this driver,
 	  you will still be able to use the parallel port for other tasks,
@@ -916,7 +916,7 @@
 	  <http://www.linuxdoc.org/docs.html#howto>.  If it doesn't work out
 	  of the box, you may have to change some settings in
 	  <file:drivers/scsi/53c7,8xx.h>.  Please read
-	  <file:drivers/scsi/README.ncr53c7xx> for the available boot time
+	  <file:Documentation/scsi/ncr53c7xx.txt> for the available boot time
 	  command line options.
 
 	  Note: there is another driver for the 53c8xx family of controllers
@@ -1048,7 +1048,7 @@
 	  only one may be active at a time.  If you have a 53c8xx board, you
 	  probably do not want to use the "NCR53c7,8xx SCSI support".
 
-	  Please read <file:drivers/scsi/README.ncr53c8xx> for more
+	  Please read <file:Documentation/scsi/ncr53c8xx.txt> for more
 	  information.
 
 config SCSI_SYM53C8XX
@@ -1075,7 +1075,7 @@
 	  SYM53C8XX driver, thus allowing the NCR53C8XX driver to attach them.
 	  The 'excl' option is also supported by the NCR53C8XX driver.
 
-	  Please read <file:drivers/scsi/README.ncr53c8xx> for more
+	  Please read <file:Documentation/scsi/ncr53c8xx.txt> for more
 	  information.
 
 config SCSI_NCR53C8XX_DEFAULT_TAGS
@@ -1301,7 +1301,7 @@
 	  SCSI support"), below.
 
 	  Information about this driver is contained in
-	  <file:drivers/scsi/README.qlogicfas>.  You should also read the
+	  <file:Documentation/scsi/qlogicfas.txt>.  You should also read the
 	  SCSI-HOWTO, available from
 	  <http://www.linuxdoc.org/docs.html#howto>.
 
@@ -1321,7 +1321,7 @@
 	  If you say Y here, make sure to choose "BIOS" at the question "PCI
 	  access mode".
 
-	  Please read the file <file:drivers/scsi/README.qlogicisp>.  You
+	  Please read the file <file:Documentation/scsi/qlogicisp.txt>.  You
 	  should also read the SCSI-HOWTO, available from
 	  <http://www.linuxdoc.org/docs.html#howto>.
 
@@ -1422,7 +1422,7 @@
 	  chip, e.g. Tekram DC390(T), DawiControl 2974 and some onboard
 	  PCscsi/PCnet (Am53/79C974) solutions.
 
-	  Documentation can be found in <file:drivers/scsi/README.tmscsim>.
+	  Documentation can be found in <file:Documentation/scsi/tmscsim.txt>.
 
 	  Note that this driver does NOT support Tekram DC390W/U/F, which are
 	  based on NCR/Symbios chips. Use "NCR53C8XX SCSI support" for those.
@@ -1442,7 +1442,7 @@
 	  EEPROM to get initial values for its settings, such as speed,
 	  termination, etc.  If it can't find this EEPROM, it will use
 	  defaults or the user supplied boot/module parameters.  For details
-	  on driver configuration see <file:drivers/scsi/README.tmscsim>.
+	  on driver configuration see <file:Documentation/scsi/tmscsim.txt>.
 
 	  If you say Y here and if no EEPROM is found, the driver gives up and
 	  thus only supports Tekram DC390(T) adapters.  This can be useful if
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/aha152x.c linux-2.5.47-scsi-doc/drivers/scsi/aha152x.c
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/aha152x.c	Mon Nov 11 08:16:51 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/aha152x.c	Mon Nov 11 08:32:34 2002
@@ -216,7 +216,7 @@
  *
  **************************************************************************
  
- see README.aha152x for configuration details
+ see Documentation/scsi/aha152x.txt for configuration details
 
  **************************************************************************/
 
@@ -1859,7 +1859,7 @@
 				       "aha152x: unable to verify geometry for disk with >1GB.\n"
 				       "         Using default translation. Please verify yourself.\n"
 				       "         Perhaps you need to enable extended translation in the driver.\n"
-				       "         See /usr/src/linux/drivers/scsi/README.aha152x for details.\n");
+				       "         See /usr/src/linux/Documentation/scsi/aha152x.txt for details.\n");
 			}
 		} else {
 			info_array[0] = info[0];
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/aic7xxx/aic7xxx_linux.c linux-2.5.47-scsi-doc/drivers/scsi/aic7xxx/aic7xxx_linux.c
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/aic7xxx/aic7xxx_linux.c	Mon Nov 11 08:16:51 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/aic7xxx/aic7xxx_linux.c	Mon Nov 11 08:32:34 2002
@@ -1074,7 +1074,7 @@
 		aic7xxx_setup(aic7xxx);
 	if (dummy_buffer[0] != 'P')
 		printk(KERN_WARNING
-"aic7xxx: Please read the file /usr/src/linux/drivers/scsi/README.aic7xxx\n"
+"aic7xxx: Please read the file /usr/src/linux/Documentation/scsi/aic7xxx.txt\n"
 "aic7xxx: to see the proper way to specify options to the aic7xxx module\n"
 "aic7xxx: Specifically, don't use any commas when passing arguments to\n"
 "aic7xxx: insmod or else it might trash certain memory areas.\n");
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/dpt/dpti_ioctl.h linux-2.5.47-scsi-doc/drivers/scsi/dpt/dpti_ioctl.h
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/dpt/dpti_ioctl.h	Mon Nov 11 08:16:51 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/dpt/dpti_ioctl.h	Mon Nov 11 08:32:34 2002
@@ -5,7 +5,8 @@
     copyright            : (C) 2001 by Adaptec
     email                : deanna_bonds@adaptec.com
 
-    See README.dpti for history, notes, license info, and credits
+    See Documentation/scsi/dpti.txt for history, notes, license info
+    and credits
  ***************************************************************************/
 
 /***************************************************************************
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/dpt_i2o.c linux-2.5.47-scsi-doc/drivers/scsi/dpt_i2o.c
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/dpt_i2o.c	Mon Nov 11 08:16:52 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/dpt_i2o.c	Mon Nov 11 08:32:34 2002
@@ -5,10 +5,11 @@
     copyright            : (C) 2000 by Adaptec
     email                : deanna_bonds@adaptec.com
 
-    			   July 30, 2001 First version being submitted
+			   July 30, 2001 First version being submitted
 			   for inclusion in the kernel.  V2.4
 
-    See README.dpti for history, notes, license info, and credits
+    See Documentation/scsi/dpti.txt for history, notes, license info
+    and credits
  ***************************************************************************/
 
 /***************************************************************************
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/dpti.h linux-2.5.47-scsi-doc/drivers/scsi/dpti.h
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/dpti.h	Mon Nov 11 08:16:50 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/dpti.h	Mon Nov 11 08:32:34 2002
@@ -5,7 +5,8 @@
     copyright            : (C) 2001 by Adaptec
     email                : deanna_bonds@adaptec.com
 
-    See README.dpti for history, notes, license info, and credits
+    See Documentation/scsi/dpti.txt for history, notes, license info
+    and credits
  ***************************************************************************/
 
 /***************************************************************************
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/ibmmca.c linux-2.5.47-scsi-doc/drivers/scsi/ibmmca.c
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/ibmmca.c	Mon Nov 11 08:16:51 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/ibmmca.c	Mon Nov 11 08:32:34 2002
@@ -4,8 +4,9 @@
  Copyright (c) 1995 Strom Systems, Inc. under the terms of the GNU
  General Public License. Written by Martin Kolinek, December 1995.
  Further development by: Chris Beauregard, Klaus Kudielka, Michael Lang
- See the file README.ibmmca for a detailed description of this driver,
- the commandline arguments and the history of its development.
+ See the file Documentation/scsi/ibmmca.txt for a detailed description
+ of this driver, the commandline arguments and the history of its
+ development.
  See the WWW-page: http://www.uni-mainz.de/~langm000/linux.html for latest
  updates, info and ADF-files for adapters supported by this driver.
 
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/ibmmca.h linux-2.5.47-scsi-doc/drivers/scsi/ibmmca.h
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/ibmmca.h	Mon Nov 11 08:16:51 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/ibmmca.h	Mon Nov 11 08:32:34 2002
@@ -1,6 +1,7 @@
-/* 
+/*
  * Low Level Driver for the IBM Microchannel SCSI Subsystem
- * (Headerfile, see README.ibmmca for description of the IBM MCA SCSI-driver
+ * (Headerfile, see Documentation/scsi/ibmmca.txt for description of the
+ * IBM MCA SCSI-driver.
  * For use under the GNU General Public License within the Linux-kernel project.
  * This include file works only correctly with kernel 2.4.0 or higher!!! */
 
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/ncr53c8xx.c linux-2.5.47-scsi-doc/drivers/scsi/ncr53c8xx.c
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/ncr53c8xx.c	Mon Nov 11 08:16:51 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/ncr53c8xx.c	Mon Nov 11 08:32:34 2002
@@ -1621,7 +1621,7 @@
 	**	Possible data corruption during Memory Write and Invalidate.
 	**	This work-around resets the addressing logic prior to the 
 	**	start of the first MOVE of a DATA IN phase.
-	**	(See README.ncr53c8xx for more information)
+	**	(See Documentation/scsi/ncr53c8xx.txt for more information)
 	*/
 	SCR_JUMPR ^ IFFALSE (IF (SCR_DATA_IN)),
 		20,
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/osst.c linux-2.5.47-scsi-doc/drivers/scsi/osst.c
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/osst.c	Mon Nov 11 08:16:51 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/osst.c	Mon Nov 11 08:32:34 2002
@@ -1,6 +1,6 @@
 /*
   SCSI Tape Driver for Linux version 1.1 and newer. See the accompanying
-  file README.st for more information.
+  file Documentation/scsi/st.txt for more information.
 
   History:
 
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/pcmcia/Kconfig linux-2.5.47-scsi-doc/drivers/scsi/pcmcia/Kconfig
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/pcmcia/Kconfig	Mon Nov 11 08:16:51 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/pcmcia/Kconfig	Mon Nov 11 08:32:34 2002
@@ -46,7 +46,7 @@
 	help
 	  If you intend to attach this type of PCMCIA SCSI host adapter to
 	  your computer, say Y here and read
-	  <file:Documentation/README.nsp_cs.eng>.
+	  <file:Documentation/scsi/NinjaSCSI.txt>.
 
 	  This driver is also available as a module called nsp_cs.o ( =
 	  code which can be inserted in and removed from the running kernel
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/qla1280.c linux-2.5.47-scsi-doc/drivers/scsi/qla1280.c
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/qla1280.c	Mon Nov 11 08:16:52 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/qla1280.c	Mon Nov 11 08:32:34 2002
@@ -955,8 +955,8 @@
 		qla1280_setup(options, NULL);
 
 	printk(KERN_WARNING
-	       "qla1280: Please read the file /usr/src/linux/drivers"
-	       "/scsi/README.qla1280\n"
+	       "qla1280: Please read the file /usr/src/linux/Documentation"
+	       "/scsi/qla1280.txt\n"
 	       "qla1280: to see the proper way to specify options to the qla1280 "
 	       "module\n"
 	       "qla1280: Specifically, don't use any commas when passing "
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/st.c linux-2.5.47-scsi-doc/drivers/scsi/st.c
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/st.c	Mon Nov 11 08:16:51 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/st.c	Mon Nov 11 08:32:34 2002
@@ -1,6 +1,6 @@
 /*
    SCSI Tape Driver for Linux version 1.1 and newer. See the accompanying
-   file README.st for more information.
+   file Documentation/scsi/st.txt for more information.
 
    History:
    Rewritten from Dwayne Forsyth's SCSI tape driver by Kai Makisara.
@@ -3576,7 +3576,7 @@
 }
 
 #ifndef MODULE
-/* Set the boot options. Syntax is defined in README.st.
+/* Set the boot options. Syntax is defined in Documenation/scsi/st.txt.
  */
 static int __init st_setup(char *str)
 {
diff -Naur linux-2.5.47-scsi-doc-moved/drivers/scsi/tmscsim.c linux-2.5.47-scsi-doc/drivers/scsi/tmscsim.c
--- linux-2.5.47-scsi-doc-moved/drivers/scsi/tmscsim.c	Mon Nov 11 08:16:52 2002
+++ linux-2.5.47-scsi-doc/drivers/scsi/tmscsim.c	Mon Nov 11 08:32:34 2002
@@ -1,17 +1,18 @@
-/***********************************************************************
- *	FILE NAME : TMSCSIM.C					       *
- *	     BY   : C.L. Huang,  ching@tekram.com.tw		       *
- *	Description: Device Driver for Tekram DC-390(T) PCI SCSI       *
- *		     Bus Master Host Adapter			       *
- * (C)Copyright 1995-1996 Tekram Technology Co., Ltd.		       *
- ***********************************************************************/
-/* (C) Copyright: put under GNU GPL in 10/96  (see README.tmscsim)	*
-*************************************************************************/
-/* $Id: tmscsim.c,v 2.60.2.30 2000/12/20 01:07:12 garloff Exp $		*/
-/*	Enhancements and bugfixes by					*
+/************************************************************************
+ *	FILE NAME : TMSCSIM.C						*
+ *	     BY   : C.L. Huang,  ching@tekram.com.tw			*
+ *	Description: Device Driver for Tekram DC-390(T) PCI SCSI	*
+ *		     Bus Master Host Adapter				*
+ * (C)Copyright 1995-1996 Tekram Technology Co., Ltd.			*
+ ************************************************************************
+ * (C) Copyright: put under GNU GPL in 10/96				*
+ *				(see Documentation/scsi/tmscsim.txt)	*
+ ************************************************************************
+ * $Id: tmscsim.c,v 2.60.2.30 2000/12/20 01:07:12 garloff Exp $		*
+ *	Enhancements and bugfixes by					*
  *	Kurt Garloff <kurt@garloff.de>	<garloff@suse.de>		*
- ***********************************************************************/
-/*	HISTORY:							*
+ ************************************************************************
+ *	HISTORY:							*
  *									*
  *	REV#	DATE	NAME	DESCRIPTION				*
  *	1.00  96/04/24	CLH	First release				*
@@ -1521,7 +1522,7 @@
     DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
     PDEVSET1; PCI_READ_CONFIG_WORD(PDEV, PCI_STATUS, &pstat);
     printk ("DC390: Register dump: PCI Status: %04x\n", pstat);
-    printk ("DC390: In case of driver trouble read linux/drivers/scsi/README.tmscsim\n");
+    printk ("DC390: In case of driver trouble read linux/Documentation/scsi/tmscsim.txt\n");
 };
 
 
diff -Naur linux-2.5.47-scsi-doc-moved/include/scsi/sg.h linux-2.5.47-scsi-doc/include/scsi/sg.h
--- linux-2.5.47-scsi-doc-moved/include/scsi/sg.h	Mon Nov 11 08:17:17 2002
+++ linux-2.5.47-scsi-doc/include/scsi/sg.h	Mon Nov 11 08:32:34 2002
@@ -69,7 +69,7 @@
 	http://www.torque.net/sg/p/scsi-generic_long.txt
  A version of this document (potentially out of date) may also be found in
  the kernel source tree, probably at:
-        /usr/src/linux/Documentation/scsi-generic.txt .
+        /usr/src/linux/Documentation/scsi/scsi-generic.txt .
 
  Utility and test programs are available at the sg web site. They are 
  bundled as sg_utils (for the lk 2.2 series) and sg3_utils (for the
