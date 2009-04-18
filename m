From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH 6/6] fnic: Patch MAINTAINERS, scsi Makefile, scsi Kconfig
Date: Fri, 17 Apr 2009 18:33:26 -0700
Message-ID: <20090418013322.24787.53673.stgit@feynman.nuovasystems.com>
References: <20090418012941.24787.58754.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:46089 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753567AbZDRBd2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2009 21:33:28 -0400
In-Reply-To: <20090418012941.24787.58754.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, abjoglek@cisco.com, jeykholt@cisco.com

Patch MAINTAINERS file, add fnic module to scsi Makefile and Kconfig

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 MAINTAINERS           |    8 ++++++++
 drivers/scsi/Kconfig  |   11 +++++++++++
 drivers/scsi/Makefile |    1 +
 3 files changed, 20 insertions(+), 0 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index ebaf77e..405f574 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1167,6 +1167,14 @@ P:	Nils Faerber (port to kernel 2.4)
 M:	Nils Faerber <nils@kernelconcepts.de>
 S:	Maintained
 
+CISCO FCOE HBA DRIVER
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
index 876cd20..d45f3ad 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -628,6 +628,17 @@ config FCOE
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
index e7c861a..a5049cf 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_SCSI_DH)		+= device_handler/
 obj-$(CONFIG_LIBFC)		+= libfc/
 obj-$(CONFIG_LIBFCOE)		+= fcoe/
 obj-$(CONFIG_FCOE)		+= fcoe/
+obj-$(CONFIG_FCOE_FNIC)		+= fnic/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
 obj-$(CONFIG_SCSI_A4000T)	+= 53c700.o	a4000t.o


