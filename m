From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [4/11]   qla2xxx: NVRAM id-list updates
Date: Wed, 8 Dec 2004 23:35:38 -0800
Message-ID: <20041209073538.GA22085@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:25591 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261475AbULIHfn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 02:35:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ChangeSet
  1.2238 04/12/08 14:30:11 andrew.vasquez@qlogic.com +1 -0
  Resync with latest NVRAM subsystem ID list.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_devtbl.h |   92 ++++++++++++++++++++++++++------------
 1 files changed, 63 insertions(+), 29 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_devtbl.h b/drivers/scsi/qla2xxx/qla_devtbl.h
--- a/drivers/scsi/qla2xxx/qla_devtbl.h	2004-12-08 22:13:51 -08:00
+++ b/drivers/scsi/qla2xxx/qla_devtbl.h	2004-12-08 22:13:51 -08:00
@@ -1,4 +1,4 @@
-#define QLA_MODEL_NAMES         0x21
+#define QLA_MODEL_NAMES         0x32
 
 /*
  * Adapter model names.
@@ -19,24 +19,41 @@
 	"QLA2350",	/* 0x10c */
 	"QLA2352",	/* 0x10d */
 	"QLA2352",	/* 0x10e */
-	"HPQSVS ",	/* 0x10f */
-	"HPQSVS ",	/* 0x110 */
-	"QLA4010",	/* 0x111 */
-	"QLA4010",	/* 0x112 */
-	"QLA4010C",	/* 0x113 */
-	"QLA4010C",	/* 0x114 */
+	"HPQ SVS",	/* 0x10f */
+	"HPQ SVS",	/* 0x110 */
+	" ",		/* 0x111 */
+	" ",		/* 0x112 */
+	" ",		/* 0x113 */
+	" ",		/* 0x114 */
 	"QLA2360",	/* 0x115 */
 	"QLA2362",	/* 0x116 */
-	" ",		/* 0x117 */
-	" ",		/* 0x118 */
+	"QLE2360",	/* 0x117 */
+	"QLE2362",	/* 0x118 */
 	"QLA200",	/* 0x119 */
-	"QLA200C"	/* 0x11A */
-	"QLA200P"	/* 0x11B */
-	"QLA200P"	/* 0x11C */
-	"QLA4040"	/* 0x11D */
-	"QLA4040"	/* 0x11E */
-	"QLA4040C"	/* 0x11F */
-	"QLA4040C"	/* 0x120 */
+	"QLA200C",	/* 0x11a */
+	"QLA200P",	/* 0x11b */
+	"QLA200P",	/* 0x11c */
+	" ",		/* 0x11d */
+	" ",		/* 0x11e */
+	" ",		/* 0x11f */
+	" ",		/* 0x120 */
+	" ",		/* 0x121 */
+	" ",		/* 0x122 */
+	" ",		/* 0x123 */
+	" ",		/* 0x124 */
+	" ",		/* 0x125 */
+	" ",		/* 0x126 */
+	" ",		/* 0x127 */
+	" ",		/* 0x128 */
+	" ",		/* 0x129 */
+	" ",		/* 0x12a */
+	" ",		/* 0x12b */
+	" ",		/* 0x12c */
+	" ",		/* 0x12d */
+	" ",		/* 0x12e */
+	"QLA210",	/* 0x12f */
+	"EMC 250",	/* 0x130 */
+	"HP A7538A"	/* 0x131 */
 };
 
 static char *qla2x00_model_desc[QLA_MODEL_NAMES] = {
@@ -57,20 +74,37 @@
 	" ",						/* 0x10e */
 	"HPQ SVS HBA- Initiator device",		/* 0x10f */
 	"HPQ SVS HBA- Target device",			/* 0x110 */
-	"Optical- 133MHz to 1Gb iSCSI- networking",	/* 0x111 */
-	"Optical- 133MHz to 1Gb iSCSI- storage",	/* 0x112 */
-	"Copper- 133MHz to 1Gb iSCSI- networking",	/* 0x113 */
-	"Copper- 133MHz to 1Gb iSCSI- storage",		/* 0x114 */
+	" ",						/* 0x111 */
+	" ",						/* 0x112 */
+	" ",						/* 0x113 */
+	" ",						/* 0x114 */
 	"133MHz PCI-X to 2Gb FC Single Channel",	/* 0x115 */
 	"133MHz PCI-X to 2Gb FC Dual Channel",		/* 0x116 */
-	" ",						/* 0x117 */
-	" ",						/* 0x118 */
+	"PCI-Express to 2Gb FC, Single Channel",	/* 0x117 */
+	"PCI-Express to 2Gb FC, Dual Channel",		/* 0x118 */
 	"133MHz PCI-X to 2Gb FC Optical",		/* 0x119 */
-	"133MHz PCI-X to 2Gb FC Copper"			/* 0x11A */
-	"133MHz PCI-X to 2Gb FC SFP"			/* 0x11B */
-	"133MHz PCI-X to 2Gb FC SFP"			/* 0x11C */
-	"Optical- 133MHz to 1Gb NIC with IPSEC",	/* 0x11D */
-	"Optical- 133MHz to 1Gb iSCSI with IPSEC",	/* 0x11E */
-	"Copper- 133MHz to 1Gb NIC with IPSEC",		/* 0x11F */
-	"Copper- 133MHz to 1Gb iSCSI with IPSEC",	/* 0x120 */
+	"133MHz PCI-X to 2Gb FC Copper",		/* 0x11a */
+	"133MHz PCI-X to 2Gb FC SFP",			/* 0x11b */
+	"133MHz PCI-X to 2Gb FC SFP",			/* 0x11c */
+	" ",						/* 0x11d */
+	" ",						/* 0x11e */
+	" ",						/* 0x11f */
+	" ",						/* 0x120 */
+	" ",						/* 0x121 */
+	" ",						/* 0x122 */
+	" ",						/* 0x123 */
+	" ",						/* 0x124 */
+	" ",						/* 0x125 */
+	" ",						/* 0x126 */
+	" ",						/* 0x127 */
+	" ",						/* 0x128 */
+	" ",						/* 0x129 */
+	" ",						/* 0x12a */
+	" ",						/* 0x12b */
+	" ",						/* 0x12c */
+	" ",						/* 0x12d */
+	" ",						/* 0x12e */
+	"133MHz PCI-X to 2Gb FC SFF",			/* 0x12f */
+	"133MHz PCI-X to 2Gb FC SFF",			/* 0x130 */
+	"HP 1p2g QLA2340"				/* 0x131 */
 };
