From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 9/11]  qla2xxx: NVRAM id-list updates.
Date: Mon, 13 Jun 2005 22:32:22 -0700 (PDT)
Message-ID: <20050614053222.12127.82869.sendpatchset@plap.qlogic.com>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:47510 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261212AbVFNFcW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 01:32:22 -0400
In-Reply-To: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

NVRAM id-list updates.

Resync with latest NVRAM subsystem ID list.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_devtbl.h |   46 +++++++++++++++++++++++++++++++++----
 1 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_devtbl.h b/drivers/scsi/qla2xxx/qla_devtbl.h
--- a/drivers/scsi/qla2xxx/qla_devtbl.h
+++ b/drivers/scsi/qla2xxx/qla_devtbl.h
@@ -1,4 +1,4 @@
-#define QLA_MODEL_NAMES         0x32
+#define QLA_MODEL_NAMES         0x44
 
 /*
  * Adapter model names.
@@ -53,7 +53,25 @@ static char *qla2x00_model_name[QLA_MODE
 	" ",		/* 0x12e */
 	"QLA210",	/* 0x12f */
 	"EMC 250",	/* 0x130 */
-	"HP A7538A"	/* 0x131 */
+	"HP A7538A",	/* 0x131 */
+	"QLA210",	/* 0x132 */
+	"QLA2460",	/* 0x133 */
+	"QLA2462",	/* 0x134 */
+	"QMC2462",	/* 0x135 */
+	"QMC2462S",	/* 0x136 */
+	"QLE2460",	/* 0x137 */
+	"QLE2462",	/* 0x138 */
+	"QME2462",	/* 0x139 */
+	"QLA2440",	/* 0x13a */
+	"QLA2442",	/* 0x13b */
+	"QSM2442",	/* 0x13c */
+	"QSM2462",	/* 0x13d */
+	"QLE210",	/* 0x13e */
+	"QLE220",	/* 0x13f */
+	"QLA2460",	/* 0x140 */
+	"QLA2462",	/* 0x141 */
+	"QLE2460",	/* 0x142 */
+	"QLE2462"	/* 0x143 */
 };
 
 static char *qla2x00_model_desc[QLA_MODEL_NAMES] = {
@@ -78,8 +96,8 @@ static char *qla2x00_model_desc[QLA_MODE
 	" ",						/* 0x112 */
 	" ",						/* 0x113 */
 	" ",						/* 0x114 */
-	"133MHz PCI-X to 2Gb FC Single Channel",	/* 0x115 */
-	"133MHz PCI-X to 2Gb FC Dual Channel",		/* 0x116 */
+	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x115 */
+	"133MHz PCI-X to 2Gb FC, Dual Channel",		/* 0x116 */
 	"PCI-Express to 2Gb FC, Single Channel",	/* 0x117 */
 	"PCI-Express to 2Gb FC, Dual Channel",		/* 0x118 */
 	"133MHz PCI-X to 2Gb FC Optical",		/* 0x119 */
@@ -106,5 +124,23 @@ static char *qla2x00_model_desc[QLA_MODE
 	" ",						/* 0x12e */
 	"133MHz PCI-X to 2Gb FC SFF",			/* 0x12f */
 	"133MHz PCI-X to 2Gb FC SFF",			/* 0x130 */
-	"HP 1p2g QLA2340"				/* 0x131 */
+	"HP 1p2g QLA2340",				/* 0x131 */
+	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x132 */
+	"PCI-X 2.0 to 4Gb FC, Single Channel",		/* 0x133 */
+	"PCI-X 2.0 to 4Gb FC, Dual Channel",		/* 0x134 */
+	"IBM eServer BC 4Gb FC Expansion Card",		/* 0x135 */
+	"IBM eServer BC 4Gb FC Expansion Card SFF",	/* 0x136 */
+	"PCI-Express to 4Gb FC, Single Channel",	/* 0x137 */
+	"PCI-Express to 4Gb FC, Dual Channel",		/* 0x138 */
+	"Dell PCI-Express to 4Gb FC, Dual Channel",	/* 0x139 */
+	"PCI-X 1.0 to 4Gb FC, Single Channel",		/* 0x13a */
+	"PCI-X 1.0 to 4Gb FC, Dual Channel",		/* 0x13b */
+	"Server I/O Module 4Gb FC, Single Channel",	/* 0x13c */
+	"Server I/O Module 4Gb FC, Single Channel",	/* 0x13d */
+	"PCI-Express to 2Gb FC, Single Channel",	/* 0x13e */
+	"PCI-Express to 4Gb FC, Single Channel",	/* 0x13f */
+	"Sun PCI-X 2.0 to 4Gb FC, Single Channel",	/* 0x140 */
+	"Sun PCI-X 2.0 to 4Gb FC, Dual Channel",	/* 0x141 */
+	"Sun PCI-Express to 2Gb FC, Single Channel",	/* 0x142 */
+	"Sun PCI-Express to 4Gb FC, Single Channel"	/* 0x143 */
 };
------------

-- 
Andrew Vasquez
