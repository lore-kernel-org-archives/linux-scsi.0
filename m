From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 4/4] scsi: arcmsr: Change driver version to
 v1.40.00.05-20180309
Date: Thu, 15 Mar 2018 14:40:25 +0800
Message-ID: <1521096025.31371.37.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Change driver version to v1.40.00.05-20180309

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 842b77a..2e51ccc 100755
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -49,7 +49,7 @@ struct device_attribute;
 #define ARCMSR_MAX_OUTSTANDING_CMD	1024
 #define ARCMSR_DEFAULT_OUTSTANDING_CMD	128
 #define ARCMSR_MIN_OUTSTANDING_CMD	32
-#define ARCMSR_DRIVER_VERSION		"v1.40.00.04-20171130"
+#define ARCMSR_DRIVER_VERSION		"v1.40.00.05-20180309"
 #define ARCMSR_SCSI_INITIATOR_ID	255
 #define ARCMSR_MAX_XFER_SECTORS		512
 #define ARCMSR_MAX_XFER_SECTORS_B	4096
