From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] link scsi_debug later
Date: Fri, 17 Mar 2006 12:44:07 -0800
Message-ID: <20060317124407.5f19cc09.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:5599 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932757AbWCQUmG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Mar 2006 15:42:06 -0500
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2006 12:42:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Link scsi-debug driver after SATA so that scsi-debug does not
interfere with real SCSI device ordering.
Yes, I was bitten by this.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2616-rc6.orig/drivers/scsi/Makefile
+++ linux-2616-rc6/drivers/scsi/Makefile
@@ -117,7 +117,6 @@ obj-$(CONFIG_SCSI_PPA)		+= ppa.o
 obj-$(CONFIG_SCSI_IMM)		+= imm.o
 obj-$(CONFIG_JAZZ_ESP)		+= NCR53C9x.o	jazz_esp.o
 obj-$(CONFIG_SUN3X_ESP)		+= NCR53C9x.o	sun3x_esp.o
-obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 obj-$(CONFIG_SCSI_FCAL)		+= fcal.o
 obj-$(CONFIG_SCSI_LASI700)	+= 53c700.o lasi700.o
 obj-$(CONFIG_SCSI_NSP32)	+= nsp32.o
@@ -140,6 +139,7 @@ obj-$(CONFIG_SCSI_SATA_MV)	+= libata.o s
 obj-$(CONFIG_SCSI_PDC_ADMA)	+= libata.o pdc_adma.o
 
 obj-$(CONFIG_ARM)		+= arm/
+obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 
 obj-$(CONFIG_CHR_DEV_ST)	+= st.o
 obj-$(CONFIG_CHR_DEV_OSST)	+= osst.o


---
