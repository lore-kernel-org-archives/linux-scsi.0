From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/13] qla2xxx: Resync with latest HBA SSID specification -- 2.2j.
Date: Fri, 23 Jun 2006 16:10:34 -0700
Message-ID: <1151104229942-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:42159 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1752156AbWFWXKf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:10:35 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_devtbl.h |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_devtbl.h b/drivers/scsi/qla2xxx/qla_devtbl.h
index a8fc0ff..dd43541 100644
--- a/drivers/scsi/qla2xxx/qla_devtbl.h
+++ b/drivers/scsi/qla2xxx/qla_devtbl.h
@@ -1,4 +1,4 @@
-#define QLA_MODEL_NAMES         0x4A
+#define QLA_MODEL_NAMES		0x57
 
 /*
  * Adapter model names and descriptions.
@@ -76,6 +76,19 @@ static char *qla2x00_model_name[QLA_MODE
 	"QLE2440",	"PCI-Express to 4Gb FC, Single Channel",	/* 0x145 */
 	"QLE2464",	"PCI-Express to 4Gb FC, Quad Channel",		/* 0x146 */
 	"QLA2440",	"PCI-X 2.0 to 4Gb FC, Single Channel",		/* 0x147 */
-	" ",		" ",						/* 0x148 */
+	"HP AE369A",	"PCI-X 2.0 to 4Gb FC, Dual Channel",		/* 0x148 */
 	"QLA2340",	"Sun 133MHz PCI-X to 2Gb FC, Single Channel",	/* 0x149 */
+	" ",		" ",						/* 0x14a */
+	" ",		" ",						/* 0x14b */
+	"QMC2432M",	"IBM eServer BC 4Gb FC Expansion Card CFFE",	/* 0x14c */
+	"QMC2422M",	"IBM eServer BC 4Gb FC Expansion Card CFFX",	/* 0x14d */
+	"QLE220",	"Sun PCI-Express to 4Gb FC, Single Channel",	/* 0x14e */
+	" ",		" ",						/* 0x14f */
+	" ",		" ",						/* 0x150 */
+	" ",		" ",						/* 0x151 */
+	"QME2462",	"PCI-Express to 4Gb FC, Dual Channel Mezz HBA",	/* 0x152 */
+	"QMH2462",	"PCI-Express to 4Gb FC, Dual Channel Mezz HBA",	/* 0x153 */
+	" ",		" ",						/* 0x154 */
+	"QLE220",	"PCI-Express to 4Gb FC, Single Channel",	/* 0x155 */
+	"QLE220",	"PCI-Express to 4Gb FC, Single Channel",	/* 0x156 */
 };
-- 
1.4.1.rc1.gf603


