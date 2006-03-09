From: andrew.vasquez@qlogic.com
Subject: [PATCH 04/10] qla2xxx: NVRAM id-list updates.
Date: Thu, 9 Mar 2006 14:27:24 -0800
Message-ID: <1141943239529-git-send-email-andrew.vasquez@qlogic.com>
References: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:63300 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751953AbWCIW1Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 17:27:24 -0500
In-Reply-To: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Resync with latest NVRAM subsystem ID list.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_devtbl.h |  219 +++++++++++++------------------------
 drivers/scsi/qla2xxx/qla_init.c   |    6 +
 2 files changed, 80 insertions(+), 145 deletions(-)

b9b88cd53c028aafda75eac4d551be8d13bd7724
diff --git a/drivers/scsi/qla2xxx/qla_devtbl.h b/drivers/scsi/qla2xxx/qla_devtbl.h
index 5109735..a8fc0ff 100644
--- a/drivers/scsi/qla2xxx/qla_devtbl.h
+++ b/drivers/scsi/qla2xxx/qla_devtbl.h
@@ -1,146 +1,81 @@
-#define QLA_MODEL_NAMES         0x44
+#define QLA_MODEL_NAMES         0x4A
 
 /*
- * Adapter model names.
+ * Adapter model names and descriptions.
  */
-static char *qla2x00_model_name[QLA_MODEL_NAMES] = {
-	"QLA2340",	/* 0x100 */
-	"QLA2342",	/* 0x101 */
-	"QLA2344",	/* 0x102 */
-	"QCP2342",	/* 0x103 */
-	"QSB2340",	/* 0x104 */
-	"QSB2342",	/* 0x105 */
-	"QLA2310",	/* 0x106 */
-	"QLA2332",	/* 0x107 */
-	"QCP2332",	/* 0x108 */
-	"QCP2340",	/* 0x109 */
-	"QLA2342",	/* 0x10a */
-	"QCP2342",	/* 0x10b */
-	"QLA2350",	/* 0x10c */
-	"QLA2352",	/* 0x10d */
-	"QLA2352",	/* 0x10e */
-	"HPQ SVS",	/* 0x10f */
-	"HPQ SVS",	/* 0x110 */
-	" ",		/* 0x111 */
-	" ",		/* 0x112 */
-	" ",		/* 0x113 */
-	" ",		/* 0x114 */
-	"QLA2360",	/* 0x115 */
-	"QLA2362",	/* 0x116 */
-	"QLE2360",	/* 0x117 */
-	"QLE2362",	/* 0x118 */
-	"QLA200",	/* 0x119 */
-	"QLA200C",	/* 0x11a */
-	"QLA200P",	/* 0x11b */
-	"QLA200P",	/* 0x11c */
-	" ",		/* 0x11d */
-	" ",		/* 0x11e */
-	" ",		/* 0x11f */
-	" ",		/* 0x120 */
-	" ",		/* 0x121 */
-	" ",		/* 0x122 */
-	" ",		/* 0x123 */
-	" ",		/* 0x124 */
-	" ",		/* 0x125 */
-	" ",		/* 0x126 */
-	" ",		/* 0x127 */
-	" ",		/* 0x128 */
-	" ",		/* 0x129 */
-	" ",		/* 0x12a */
-	" ",		/* 0x12b */
-	" ",		/* 0x12c */
-	" ",		/* 0x12d */
-	" ",		/* 0x12e */
-	"QLA210",	/* 0x12f */
-	"EMC 250",	/* 0x130 */
-	"HP A7538A",	/* 0x131 */
-	"QLA210",	/* 0x132 */
-	"QLA2460",	/* 0x133 */
-	"QLA2462",	/* 0x134 */
-	"QMC2462",	/* 0x135 */
-	"QMC2462S",	/* 0x136 */
-	"QLE2460",	/* 0x137 */
-	"QLE2462",	/* 0x138 */
-	"QME2462",	/* 0x139 */
-	"QLA2440",	/* 0x13a */
-	"QLA2442",	/* 0x13b */
-	"QSM2442",	/* 0x13c */
-	"QSM2462",	/* 0x13d */
-	"QLE210",	/* 0x13e */
-	"QLE220",	/* 0x13f */
-	"QLA2460",	/* 0x140 */
-	"QLA2462",	/* 0x141 */
-	"QLE2460",	/* 0x142 */
-	"QLE2462"	/* 0x143 */
-};
-
-static char *qla2x00_model_desc[QLA_MODEL_NAMES] = {
-	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x100 */
-	"133MHz PCI-X to 2Gb FC, Dual Channel",		/* 0x101 */
-	"133MHz PCI-X to 2Gb FC, Quad Channel",		/* 0x102 */
-	" ",						/* 0x103 */
-	" ",						/* 0x104 */
-	" ",						/* 0x105 */
-	" ",						/* 0x106 */
-	" ",						/* 0x107 */
-	" ",						/* 0x108 */
-	" ",						/* 0x109 */
-	" ",						/* 0x10a */
-	" ",						/* 0x10b */
-	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x10c */
-	"133MHz PCI-X to 2Gb FC, Dual Channel",		/* 0x10d */
-	" ",						/* 0x10e */
-	"HPQ SVS HBA- Initiator device",		/* 0x10f */
-	"HPQ SVS HBA- Target device",			/* 0x110 */
-	" ",						/* 0x111 */
-	" ",						/* 0x112 */
-	" ",						/* 0x113 */
-	" ",						/* 0x114 */
-	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x115 */
-	"133MHz PCI-X to 2Gb FC, Dual Channel",		/* 0x116 */
-	"PCI-Express to 2Gb FC, Single Channel",	/* 0x117 */
-	"PCI-Express to 2Gb FC, Dual Channel",		/* 0x118 */
-	"133MHz PCI-X to 2Gb FC Optical",		/* 0x119 */
-	"133MHz PCI-X to 2Gb FC Copper",		/* 0x11a */
-	"133MHz PCI-X to 2Gb FC SFP",			/* 0x11b */
-	"133MHz PCI-X to 2Gb FC SFP",			/* 0x11c */
-	" ",						/* 0x11d */
-	" ",						/* 0x11e */
-	" ",						/* 0x11f */
-	" ",						/* 0x120 */
-	" ",						/* 0x121 */
-	" ",						/* 0x122 */
-	" ",						/* 0x123 */
-	" ",						/* 0x124 */
-	" ",						/* 0x125 */
-	" ",						/* 0x126 */
-	" ",						/* 0x127 */
-	" ",						/* 0x128 */
-	" ",						/* 0x129 */
-	" ",						/* 0x12a */
-	" ",						/* 0x12b */
-	" ",						/* 0x12c */
-	" ",						/* 0x12d */
-	" ",						/* 0x12e */
-	"133MHz PCI-X to 2Gb FC SFF",			/* 0x12f */
-	"133MHz PCI-X to 2Gb FC SFF",			/* 0x130 */
-	"HP 1p2g QLA2340",				/* 0x131 */
-	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x132 */
-	"PCI-X 2.0 to 4Gb FC, Single Channel",		/* 0x133 */
-	"PCI-X 2.0 to 4Gb FC, Dual Channel",		/* 0x134 */
-	"IBM eServer BC 4Gb FC Expansion Card",		/* 0x135 */
-	"IBM eServer BC 4Gb FC Expansion Card SFF",	/* 0x136 */
-	"PCI-Express to 4Gb FC, Single Channel",	/* 0x137 */
-	"PCI-Express to 4Gb FC, Dual Channel",		/* 0x138 */
-	"Dell PCI-Express to 4Gb FC, Dual Channel",	/* 0x139 */
-	"PCI-X 1.0 to 4Gb FC, Single Channel",		/* 0x13a */
-	"PCI-X 1.0 to 4Gb FC, Dual Channel",		/* 0x13b */
-	"Server I/O Module 4Gb FC, Single Channel",	/* 0x13c */
-	"Server I/O Module 4Gb FC, Single Channel",	/* 0x13d */
-	"PCI-Express to 2Gb FC, Single Channel",	/* 0x13e */
-	"PCI-Express to 4Gb FC, Single Channel",	/* 0x13f */
-	"Sun PCI-X 2.0 to 4Gb FC, Single Channel",	/* 0x140 */
-	"Sun PCI-X 2.0 to 4Gb FC, Dual Channel",	/* 0x141 */
-	"Sun PCI-Express to 2Gb FC, Single Channel",	/* 0x142 */
-	"Sun PCI-Express to 4Gb FC, Single Channel"	/* 0x143 */
+static char *qla2x00_model_name[QLA_MODEL_NAMES*2] = {
+	"QLA2340",	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x100 */
+	"QLA2342",	"133MHz PCI-X to 2Gb FC, Dual Channel",		/* 0x101 */
+	"QLA2344",	"133MHz PCI-X to 2Gb FC, Quad Channel",		/* 0x102 */
+	"QCP2342",	"cPCI to 2Gb FC, Dual Channel",			/* 0x103 */
+	"QSB2340",	"SBUS to 2Gb FC, Single Channel",		/* 0x104 */
+	"QSB2342",	"SBUS to 2Gb FC, Dual Channel",			/* 0x105 */
+	"QLA2310",	"Sun 66MHz PCI-X to 2Gb FC, Single Channel",	/* 0x106 */
+	"QLA2332",	"Sun 66MHz PCI-X to 2Gb FC, Single Channel",	/* 0x107 */
+	"QCP2332",	"Sun cPCI to 2Gb FC, Dual Channel",		/* 0x108 */
+	"QCP2340",	"cPCI to 2Gb FC, Single Channel",		/* 0x109 */
+	"QLA2342",	"Sun 133MHz PCI-X to 2Gb FC, Dual Channel",	/* 0x10a */
+	"QCP2342",	"Sun - cPCI to 2Gb FC, Dual Channel",		/* 0x10b */
+	"QLA2350",	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x10c */
+	"QLA2352",	"133MHz PCI-X to 2Gb FC, Dual Channel",		/* 0x10d */
+	"QLA2352",	"Sun 133MHz PCI-X to 2Gb FC, Dual Channel",	/* 0x10e */
+	" ",		" ",						/* 0x10f */
+	" ",		" ",						/* 0x110 */
+	" ",		" ",						/* 0x111 */
+	" ",		" ",						/* 0x112 */
+	" ",		" ",						/* 0x113 */
+	" ",		" ",						/* 0x114 */
+	"QLA2360",	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x115 */
+	"QLA2362",	"133MHz PCI-X to 2Gb FC, Dual Channel",		/* 0x116 */
+	"QLE2360",	"PCI-Express to 2Gb FC, Single Channel",	/* 0x117 */
+	"QLE2362",	"PCI-Express to 2Gb FC, Dual Channel",		/* 0x118 */
+	"QLA200",	"133MHz PCI-X to 2Gb FC Optical",		/* 0x119 */
+	" ",		" ",						/* 0x11a */
+	" ",		" ",						/* 0x11b */
+	"QLA200P",	"133MHz PCI-X to 2Gb FC SFP",			/* 0x11c */
+	" ",		" ",						/* 0x11d */
+	" ",		" ",						/* 0x11e */
+	" ",		" ",						/* 0x11f */
+	" ",		" ",						/* 0x120 */
+	" ",		" ",						/* 0x121 */
+	" ",		" ",						/* 0x122 */
+	" ",		" ",						/* 0x123 */
+	" ",		" ",						/* 0x124 */
+	" ",		" ",						/* 0x125 */
+	" ",		" ",						/* 0x126 */
+	" ",		" ",						/* 0x127 */
+	" ",		" ",						/* 0x128 */
+	" ",		" ",						/* 0x129 */
+	" ",		" ",						/* 0x12a */
+	" ",		" ",						/* 0x12b */
+	" ",		" ",						/* 0x12c */
+	" ",		" ",						/* 0x12d */
+	" ",		" ",						/* 0x12e */
+	"QLA210",	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x12f */
+	"EMC 250",	"133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x130 */
+	"HP A7538A",	"HP 1p2g PCI-X to 2Gb FC, Single Channel",	/* 0x131 */
+	"QLA210",	"Sun 133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x132 */
+	"QLA2460",	"PCI-X 2.0 to 4Gb FC, Single Channel",		/* 0x133 */
+	"QLA2462",	"PCI-X 2.0 to 4Gb FC, Dual Channel",		/* 0x134 */
+	"QMC2462",	"IBM eServer BC 4Gb FC Expansion Card",		/* 0x135 */
+	"QMC2462S",	"IBM eServer BC 4Gb FC Expansion Card SFF",	/* 0x136 */
+	"QLE2460",	"PCI-Express to 4Gb FC, Single Channel",	/* 0x137 */
+	"QLE2462",	"PCI-Express to 4Gb FC, Dual Channel",		/* 0x138 */
+	"QME2462",	"Dell BS PCI-Express to 4Gb FC, Dual Channel",	/* 0x139 */
+	" ",		" ",						/* 0x13a */
+	" ",		" ",						/* 0x13b */
+	" ",		" ",						/* 0x13c */
+	"QEM2462",	"Sun Server I/O Module 4Gb FC, Dual Channel",	/* 0x13d */
+	"QLE210",	"PCI-Express to 2Gb FC, Single Channel",	/* 0x13e */
+	"QLE220",	"PCI-Express to 4Gb FC, Single Channel",	/* 0x13f */
+	"QLA2460",	"Sun PCI-X 2.0 to 4Gb FC, Single Channel",	/* 0x140 */
+	"QLA2462",	"Sun PCI-X 2.0 to 4Gb FC, Dual Channel",	/* 0x141 */
+	"QLE2460",	"Sun PCI-Express to 2Gb FC, Single Channel",	/* 0x142 */
+	"QLE2462",	"Sun PCI-Express to 4Gb FC, Single Channel",	/* 0x143 */
+	"QEM2462"	"Server I/O Module 4Gb FC, Dual Channel",	/* 0x144 */
+	"QLE2440",	"PCI-Express to 4Gb FC, Single Channel",	/* 0x145 */
+	"QLE2464",	"PCI-Express to 4Gb FC, Quad Channel",		/* 0x146 */
+	"QLA2440",	"PCI-X 2.0 to 4Gb FC, Single Channel",		/* 0x147 */
+	" ",		" ",						/* 0x148 */
+	"QLA2340",	"Sun 133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x149 */
 };
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d438909..3bc3e17 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1505,9 +1505,9 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 				index = (ha->pdev->subsystem_device & 0xff);
 				if (index < QLA_MODEL_NAMES) {
 					strcpy(ha->model_number,
-					    qla2x00_model_name[index]);
+					    qla2x00_model_name[index * 2]);
 					ha->model_desc =
-					    qla2x00_model_desc[index];
+					    qla2x00_model_name[index * 2 + 1];
 				} else {
 					strcpy(ha->model_number, "QLA23xx");
 				}
@@ -3373,7 +3373,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 
 		index = (ha->pdev->subsystem_device & 0xff);
 		if (index < QLA_MODEL_NAMES)
-			ha->model_desc = qla2x00_model_desc[index];
+			ha->model_desc = qla2x00_model_name[index * 2 + 1];
 	} else
 		strcpy(ha->model_number, "QLA2462");
 
-- 
1.2.4.gf067


