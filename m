From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [9/15] qla2xxx:  NVRAM id-list updates
Date: Sun, 14 Mar 2004 00:25:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082525.GA3444@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:37045 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263321AbUCNIWz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:22:55 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1665 04/03/01 14:34:32 andrew.vasquez@apc.qlogic.com +1 -0
  Resync with latest NVRAM subsystem ID list.

 drivers/scsi/qla2xxx/qla_devtbl.h |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/18_nvram_id_list.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_devtbl.h b/drivers/scsi/qla2xxx/qla_devtbl.h
--- a/drivers/scsi/qla2xxx/qla_devtbl.h	Fri Mar 12 17:08:32 2004
+++ b/drivers/scsi/qla2xxx/qla_devtbl.h	Fri Mar 12 17:08:32 2004
@@ -1,4 +1,4 @@
-#define QLA_MODEL_NAMES         0x1B
+#define QLA_MODEL_NAMES         0x21
 
 /*
  * Adapter model names.
@@ -31,6 +31,12 @@
 	" ",		/* 0x118 */
 	"QLA200",	/* 0x119 */
 	"QLA200C"	/* 0x11A */
+	"QLA200P"	/* 0x11B */
+	"QLA200P"	/* 0x11C */
+	"QLA4040"	/* 0x11D */
+	"QLA4040"	/* 0x11E */
+	"QLA4040C"	/* 0x11F */
+	"QLA4040C"	/* 0x120 */
 };
 
 char	*qla2x00_model_desc[QLA_MODEL_NAMES] = {
@@ -61,5 +67,10 @@
 	" ",						/* 0x118 */
 	"133MHz PCI-X to 2Gb FC Optical",		/* 0x119 */
 	"133MHz PCI-X to 2Gb FC Copper"			/* 0x11A */
+	"133MHz PCI-X to 2Gb FC SFP"			/* 0x11B */
+	"133MHz PCI-X to 2Gb FC SFP"			/* 0x11C */
+	"Optical- 133MHz to 1Gb NIC with IPSEC",	/* 0x11D */
+	"Optical- 133MHz to 1Gb iSCSI with IPSEC",	/* 0x11E */
+	"Copper- 133MHz to 1Gb NIC with IPSEC",		/* 0x11F */
+	"Copper- 133MHz to 1Gb iSCSI with IPSEC",	/* 0x120 */
 };
-
