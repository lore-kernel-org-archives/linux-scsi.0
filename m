From: Matthew Wilcox <willy@debian.org>
Subject: [KCONFIG] Make the scsi menu completely selfcontained
Date: Mon, 23 Jun 2003 18:00:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030623170009.GI2620@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:8665 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266048AbTFWQqD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 12:46:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: linux-arch@vger.kernel.org, linux-scsi@vger.kernel.org


Hi Linus.  This patch moves the rest of the SCSI Kconfig text into the
SCSI menu.  I also updated the helptext to indicate that you need SCSI
for firewire and USB storage.

 arch/alpha/Kconfig     |   25 -------------------------
 arch/arm/Kconfig       |   25 -------------------------
 arch/arm26/Kconfig     |   24 ------------------------
 arch/cris/Kconfig      |   25 -------------------------
 arch/i386/Kconfig      |   25 -------------------------
 arch/ia64/Kconfig      |   24 ------------------------
 arch/m68k/Kconfig      |   25 -------------------------
 arch/m68knommu/Kconfig |   14 --------------
 arch/mips/Kconfig      |   26 --------------------------
 arch/mips64/Kconfig    |   25 -------------------------
 arch/parisc/Kconfig    |   28 +---------------------------
 arch/ppc/Kconfig       |   25 -------------------------
 arch/ppc64/Kconfig     |   25 -------------------------
 arch/s390/Kconfig      |    7 -------
 arch/sh/Kconfig        |   25 -------------------------
 arch/sparc/Kconfig     |   25 -------------------------
 arch/sparc64/Kconfig   |   25 -------------------------
 arch/v850/Kconfig      |    9 ---------
 arch/x86_64/Kconfig    |   25 -------------------------
 drivers/scsi/Kconfig   |   40 +++++++++++++++++++++++++++++++++-------
 20 files changed, 34 insertions(+), 438 deletions(-)

Index: arch/alpha/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/alpha/Kconfig,v
retrieving revision 1.16
diff -u -p -r1.16 Kconfig
--- arch/alpha/Kconfig	23 Jun 2003 03:29:54 -0000	1.16
+++ arch/alpha/Kconfig	23 Jun 2003 16:25:27 -0000
@@ -665,32 +665,7 @@ source "drivers/md/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 if PCI
 source "drivers/message/fusion/Kconfig"
Index: arch/arm/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/arm/Kconfig,v
retrieving revision 1.16
diff -u -p -r1.16 Kconfig
--- arch/arm/Kconfig	23 Jun 2003 03:29:55 -0000	1.16
+++ arch/arm/Kconfig	23 Jun 2003 16:25:30 -0000
@@ -898,32 +898,7 @@ source "net/ax25/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 source "drivers/ieee1394/Kconfig"
 
Index: arch/arm26/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/arm26/Kconfig,v
retrieving revision 1.3
diff -u -p -r1.3 Kconfig
--- arch/arm26/Kconfig	23 Jun 2003 03:29:57 -0000	1.3
+++ arch/arm26/Kconfig	23 Jun 2003 16:24:33 -0000
@@ -364,31 +364,7 @@ source "drivers/ide/Kconfig"
 endmenu
 
 
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 source "drivers/isdn/Kconfig"
 
Index: arch/cris/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/cris/Kconfig,v
retrieving revision 1.10
diff -u -p -r1.10 Kconfig
--- arch/cris/Kconfig	23 Jun 2003 03:29:57 -0000	1.10
+++ arch/cris/Kconfig	23 Jun 2003 16:25:48 -0000
@@ -533,32 +533,7 @@ source "drivers/md/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 source "drivers/ieee1394/Kconfig"
 
Index: arch/i386/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/i386/Kconfig,v
retrieving revision 1.25
diff -u -p -r1.25 Kconfig
--- arch/i386/Kconfig	23 Jun 2003 03:29:57 -0000	1.25
+++ arch/i386/Kconfig	23 Jun 2003 16:25:55 -0000
@@ -1206,32 +1206,7 @@ source "drivers/block/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI device support"
-
-config SCSI
-	tristate "SCSI device support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 
 menu "Old CD-ROM drivers (not SCSI, not IDE)"
Index: arch/ia64/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/ia64/Kconfig,v
retrieving revision 1.15
diff -u -p -r1.15 Kconfig
--- arch/ia64/Kconfig	23 Jun 2003 03:29:59 -0000	1.15
+++ arch/ia64/Kconfig	23 Jun 2003 16:12:40 -0000
@@ -555,31 +555,7 @@ source "drivers/message/fusion/Kconfig"
 endif
 
 
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 source "net/Kconfig"
 
Index: arch/m68k/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/m68k/Kconfig,v
retrieving revision 1.15
diff -u -p -r1.15 Kconfig
--- arch/m68k/Kconfig	23 Jun 2003 03:30:09 -0000	1.15
+++ arch/m68k/Kconfig	23 Jun 2003 16:15:33 -0000
@@ -585,32 +585,7 @@ source "drivers/input/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI device support"
-
-config SCSI
-	tristate "SCSI device support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 source "net/Kconfig"
 
Index: arch/m68knommu/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/m68knommu/Kconfig,v
retrieving revision 1.13
diff -u -p -r1.13 Kconfig
--- arch/m68knommu/Kconfig	23 Jun 2003 03:30:09 -0000	1.13
+++ arch/m68knommu/Kconfig	23 Jun 2003 16:26:03 -0000
@@ -527,21 +527,7 @@ source "drivers/block/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI device support"
-
-config SCSI
-	tristate "SCSI device support"
-	help
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 
 menu "Old CD-ROM drivers (not SCSI, not IDE)"
Index: arch/mips/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/mips/Kconfig,v
retrieving revision 1.12
diff -u -p -r1.12 Kconfig
--- arch/mips/Kconfig	23 Jun 2003 03:30:10 -0000	1.12
+++ arch/mips/Kconfig	23 Jun 2003 16:26:10 -0000
@@ -758,33 +758,7 @@ if !SGI_IP22 && !DECSTATION
 source "drivers/ide/Kconfig"
 endif
 
-
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
-
 
 if !DECSTATION && !SGI_IP22
 source "drivers/message/i2o/Kconfig"
Index: arch/mips64/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/mips64/Kconfig,v
retrieving revision 1.14
diff -u -p -r1.14 Kconfig
--- arch/mips64/Kconfig	23 Jun 2003 03:30:11 -0000	1.14
+++ arch/mips64/Kconfig	23 Jun 2003 16:26:13 -0000
@@ -373,32 +373,7 @@ source "drivers/md/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 #source drivers/message/i2o/Config.in
 source "net/Kconfig"
Index: arch/parisc/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/parisc/Kconfig,v
retrieving revision 1.21
diff -u -p -r1.21 Kconfig
--- arch/parisc/Kconfig	23 Jun 2003 03:30:12 -0000	1.21
+++ arch/parisc/Kconfig	23 Jun 2003 16:26:18 -0000
@@ -182,33 +182,7 @@ source "drivers/block/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
-source drivers/scsi/Kconfig
-
-
-endmenu
+source "drivers/scsi/Kconfig"
 
 source "drivers/md/Kconfig"
 
Index: arch/ppc/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/ppc/Kconfig,v
retrieving revision 1.15
diff -u -p -r1.15 Kconfig
--- arch/ppc/Kconfig	23 Jun 2003 03:30:12 -0000	1.15
+++ arch/ppc/Kconfig	23 Jun 2003 16:26:21 -0000
@@ -1175,32 +1175,7 @@ source "drivers/md/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 source "drivers/message/fusion/Kconfig"
 
Index: arch/ppc64/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/ppc64/Kconfig,v
retrieving revision 1.14
diff -u -p -r1.14 Kconfig
--- arch/ppc64/Kconfig	23 Jun 2003 03:30:12 -0000	1.14
+++ arch/ppc64/Kconfig	23 Jun 2003 16:26:26 -0000
@@ -253,32 +253,7 @@ source "drivers/block/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI device support"
-
-config SCSI
-	tristate "SCSI device support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 source "drivers/md/Kconfig"
 
Index: arch/s390/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/s390/Kconfig,v
retrieving revision 1.12
diff -u -p -r1.12 Kconfig
--- arch/s390/Kconfig	23 Jun 2003 03:30:13 -0000	1.12
+++ arch/s390/Kconfig	23 Jun 2003 16:15:47 -0000
@@ -231,14 +231,7 @@ config PCMCIA
 
 source "drivers/base/Kconfig"
 
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 source "drivers/s390/Kconfig"
 
Index: arch/sh/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/sh/Kconfig,v
retrieving revision 1.13
diff -u -p -r1.13 Kconfig
--- arch/sh/Kconfig	23 Jun 2003 03:30:13 -0000	1.13
+++ arch/sh/Kconfig	23 Jun 2003 16:26:31 -0000
@@ -777,32 +777,7 @@ source "drivers/block/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI device support"
-
-config SCSI
-	tristate "SCSI device support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 
 menu "Old CD-ROM drivers (not SCSI, not IDE)"
Index: arch/sparc/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/sparc/Kconfig,v
retrieving revision 1.15
diff -u -p -r1.15 Kconfig
--- arch/sparc/Kconfig	23 Jun 2003 03:30:13 -0000	1.15
+++ arch/sparc/Kconfig	23 Jun 2003 16:15:57 -0000
@@ -481,32 +481,7 @@ endif
 
 source "drivers/isdn/Kconfig"
 
-
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 source "drivers/fc4/Kconfig"
 
Index: arch/sparc64/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/sparc64/Kconfig,v
retrieving revision 1.17
diff -u -p -r1.17 Kconfig
--- arch/sparc64/Kconfig	23 Jun 2003 03:30:14 -0000	1.17
+++ arch/sparc64/Kconfig	23 Jun 2003 16:16:19 -0000
@@ -675,32 +675,7 @@ endmenu
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI support"
-
-config SCSI
-	tristate "SCSI support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 source "drivers/fc4/Kconfig"
 
Index: arch/v850/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/v850/Kconfig,v
retrieving revision 1.14
diff -u -p -r1.14 Kconfig
--- arch/v850/Kconfig	23 Jun 2003 03:30:14 -0000	1.14
+++ arch/v850/Kconfig	23 Jun 2003 16:12:53 -0000
@@ -265,15 +265,6 @@ menu "Disk device support"
 
 source "drivers/ide/Kconfig"
 
-config SCSI
-	tristate "SCSI device support"
-	help
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
 source "drivers/scsi/Kconfig"
 
 endmenu
Index: arch/x86_64/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/x86_64/Kconfig,v
retrieving revision 1.20
diff -u -p -r1.20 Kconfig
--- arch/x86_64/Kconfig	23 Jun 2003 03:30:14 -0000	1.20
+++ arch/x86_64/Kconfig	23 Jun 2003 16:26:47 -0000
@@ -407,32 +407,7 @@ source "drivers/block/Kconfig"
 
 source "drivers/ide/Kconfig"
 
-
-menu "SCSI device support"
-
-config SCSI
-	tristate "SCSI device support"
-	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you want support for the parallel
-	  port version of the 100 MB IOMEGA ZIP drive.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called scsi_mod.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI device.
-
 source "drivers/scsi/Kconfig"
-
-endmenu
 
 source "drivers/md/Kconfig"
 
Index: drivers/scsi/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/drivers/scsi/Kconfig,v
retrieving revision 1.15
diff -u -p -r1.15 Kconfig
--- drivers/scsi/Kconfig	23 Jun 2003 03:30:27 -0000	1.15
+++ drivers/scsi/Kconfig	23 Jun 2003 16:13:00 -0000
@@ -1,3 +1,27 @@
+menu "SCSI device support"
+
+config SCSI
+	tristate "SCSI device support"
+	---help---
+	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
+	  any other SCSI device under Linux, say Y and make sure that you know
+	  the name of your SCSI host adapter (the card inside your computer
+	  that "speaks" the SCSI protocol, also called SCSI controller),
+	  because you will be asked for it.
+
+	  You also need to say Y here if you have a device which speaks
+	  the SCSI protocol.  Examples of this include the parallel port
+	  version of the IOMEGA ZIP drive, USB storage devices, Fibre
+	  Channel, FireWire storage and the IDE-SCSI emulation driver.
+
+	  This driver is also available as a module ( = code which can be
+	  inserted in and removed from the running kernel whenever you want).
+	  The module will be called scsi_mod.  If you want to compile it as
+	  a module, say M here and read <file:Documentation/modules.txt> and
+	  <file:Documentation/scsi/scsi.txt>.  However, do not compile this as a
+	  module if your root file system (the one containing the directory /)
+	  is located on a SCSI device.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
@@ -5,9 +29,10 @@ config BLK_DEV_SD
 	tristate "SCSI disk support"
 	depends on SCSI
 	---help---
-	  If you want to use a SCSI hard disk or the SCSI or parallel port
-	  version of the IOMEGA ZIP drive under Linux, say Y and read the
-	  SCSI-HOWTO, the Disk-HOWTO and the Multi-Disk-HOWTO, available from
+	  If you want to use SCSI hard disks, Fibre Channel disks,
+	  USB storage or the SCSI or parallel port version of
+	  the IOMEGA ZIP drive, say Y and read the SCSI-HOWTO,
+	  the Disk-HOWTO and the Multi-Disk-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>. This is NOT for SCSI
 	  CD-ROMs.
 
@@ -65,10 +90,10 @@ config BLK_DEV_SR
 	tristate "SCSI CDROM support"
 	depends on SCSI
 	---help---
-	  If you want to use a SCSI CD-ROM under Linux, say Y and read the
-	  SCSI-HOWTO and the CD-ROM-HOWTO at
-	  <http://www.tldp.org/docs.html#howto>. Also make sure to say Y
-	  or M to "ISO 9660 CD-ROM file system support" later.
+	  If you want to use a SCSI or FireWire CD-ROM under Linux,
+	  say Y and read the SCSI-HOWTO and the CDROM-HOWTO at
+	  <http://www.tldp.org/docs.html#howto>. Also make sure to say
+	  Y or M to "ISO 9660 CD-ROM file system support" later.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
@@ -1821,5 +1815,6 @@ config WD33C93_PIO
 #      bool 'GVP Turbo 040/060 SCSI support (EXPERIMENTAL)' CONFIG_GVP_TURBO_SCSI
 endmenu
 
 source "drivers/scsi/pcmcia/Kconfig"
 
+endmenu

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
