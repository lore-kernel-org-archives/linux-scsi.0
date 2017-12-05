From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 4/17] scsi: arcmsr: enable host controller command queueu
 up to 1024
Date: Tue, 05 Dec 2017 09:41:25 +0800
Message-ID: <1512438085.4577.42.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, sfr@canb.auug.org.au
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

update ARCMSR_MAX_OUTSTANDING_CMD and ARCMSR_MAX_FREECCB_NUM to 1024

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2017-08-04 11:19:22.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2017-12-05 15:24:16.000000000 +0800
@@ -45,13 +45,8 @@
 #include <linux/interrupt.h>
 struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
-#ifdef CONFIG_XEN
-	#define ARCMSR_MAX_FREECCB_NUM	160
-#define ARCMSR_MAX_OUTSTANDING_CMD	155
-#else
-	#define ARCMSR_MAX_FREECCB_NUM	320
-#define ARCMSR_MAX_OUTSTANDING_CMD	255
-#endif
+#define ARCMSR_MAX_FREECCB_NUM		1024
+#define ARCMSR_MAX_OUTSTANDING_CMD	1024
 #define ARCMSR_DRIVER_VERSION		"v1.30.00.22-20151126"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
