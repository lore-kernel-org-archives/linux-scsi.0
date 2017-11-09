From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 13/13] scsi: arcmsr: update driver version to
 v1.40.00.02-20171011
Date: Thu, 09 Nov 2017 08:32:26 +0800
Message-ID: <1510187546.4523.99.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

update driver version to v1.40.00.02-20171011

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2017-11-07 17:29:10.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2017-11-07 17:50:06.000000000 +0800
@@ -54,7 +54,7 @@ struct device_attribute;
 #endif
 #define ARCMSR_DEFAULT_OUTSTANDING_CMD	128
 #define ARCMSR_MIN_OUTSTANDING_CMD	32
-#define ARCMSR_DRIVER_VERSION		"v1.30.00.22-20151126"
+#define ARCMSR_DRIVER_VERSION		"v1.40.00.02-20171011"
 #define ARCMSR_SCSI_INITIATOR_ID	255
 #define ARCMSR_MAX_XFER_SECTORS		512
 #define ARCMSR_MAX_XFER_SECTORS_B	4096
