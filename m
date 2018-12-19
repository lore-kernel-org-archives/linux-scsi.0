From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 9/12] scsi: arcmsr: Add an option of set dma_mask_64 for
 ACB_ADAPTER_TYPE_A
Date: Wed, 19 Dec 2018 16:53:44 +0800
Message-ID: <1545209624.4457.41.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Add an option of set dma_mask_64 for ACB_ADAPTER_TYPE_A

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 8cc2134..45f1374 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -91,6 +91,10 @@ static int cmd_per_lun = ARCMSR_DEFAULT_CMD_PERLUN;
 module_param(cmd_per_lun, int, S_IRUGO);
 MODULE_PARM_DESC(cmd_per_lun, " device queue depth(1 ~ 128), default is 32");
 
+static int dma_mask_64 = 0;
+module_param(dma_mask_64, int, S_IRUGO);
+MODULE_PARM_DESC(dma_mask_64, " set DMA mask to 64 bits(0 ~ 1), dma_mask_64=1(64 bits), =0(32 bits)");
+
 static int set_date_time = 0;
 module_param(set_date_time, int, S_IRUGO);
 MODULE_PARM_DESC(set_date_time, " send date, time to iop(0 ~ 1), set_date_time=1(enable), default(=0) is disable");
