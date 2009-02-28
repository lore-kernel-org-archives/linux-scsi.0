From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [RFC][PATCH 6/6] fnic: Patch MAINTAINERS, scsi Makefile, scsi Kconfig
Date: Fri, 27 Feb 2009 18:32:45 -0800
Message-ID: <20090228023241.12158.90361.stgit@feynman.nuovasystems.com>
References: <20090228022152.12158.11200.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:26822 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753404AbZB1CqK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 21:46:10 -0500
In-Reply-To: <20090228022152.12158.11200.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, jeykholt@cisco.com

fnic: Patch MAINTAINERS, scsi Makefile, scsi Kconfig



Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
---
 MAINTAINERS           |    8 ++++++++
 drivers/scsi/Kconfig  |   11 +++++++++++
 drivers/scsi/Makefile |    1 +
 3 files changed, 20 insertions(+), 0 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index 59fd2d1..5617798 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1144,6 +1144,14 @@ P:	Nils Faerber (port to kernel 2.4)
 M:	Nils Faerber <nils@kernelconcepts.de>
 S:	Maintained
 
+CISCO FCoE HBA DRIVER (drivers/scsi/fnic)
+P:	Abhijeet Joglekar
+M:	abjoglek@cisco.com
+P:	Joe Eykholt
+M:	jeykholt@cisco.com
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+
 CODA FILE SYSTEM
 P:	Jan Harkes
 M:	jaharkes@cs.cmu.edu
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 256c7be..236bb39 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -618,6 +618,17 @@ config FCOE
 	---help---
 	  Fibre Channel over Ethernet module
 
+config FCOE_FNIC
+	tristate "Cisco FNIC Driver"
+	depends on PCI && X86
+	select LIBFC
+	help
+	  This is support for the Cisco PCI-Express FCoE HBA.
+
+	  To compile this driver as a module, choose M here and read
+	  <file:Documentation/scsi/scsi.txt>.
+	  The module will be called fnic.
+
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 7461eb0..e0aed2f 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_SCSI_DH)		+= device_handler/
 
 obj-$(CONFIG_LIBFC)		+= libfc/
 obj-$(CONFIG_FCOE)		+= fcoe/
+obj-$(CONFIG_FCOE_FNIC)		+= fnic/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
 obj-$(CONFIG_SCSI_A4000T)	+= 53c700.o	a4000t.o


