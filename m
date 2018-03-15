From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 1/4] scsi: arcmsr: Rename ACB_F_BUS_HANG_ON to
 ACB_F_ADAPTER_REMOVED for adapter hot-plug
Date: Thu, 15 Mar 2018 14:26:15 +0800
Message-ID: <1521095175.31371.26.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Rename ACB_F_BUS_HANG_ON to ACB_F_ADAPTER_REMOVED for adapter hot-plug.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index f375f35..842b77a 100755
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -779,12 +779,12 @@ struct AdapterControlBlock
 /* message clear rqbuffer */
 #define ACB_F_MESSAGE_WQBUFFER_READED   0x0040
 #define ACB_F_BUS_RESET               	0x0080
-#define ACB_F_BUS_HANG_ON		0x0800/* need hardware reset bus */
 
 #define ACB_F_IOP_INITED              	0x0100
 /* iop init */
 #define ACB_F_ABORT			0x0200
 #define ACB_F_FIRMWARE_TRAP           	0x0400
+#define ACB_F_ADAPTER_REMOVED		0x0800
 #define ACB_F_MSG_GET_CONFIG		0x1000
 	struct CommandControlBlock *	pccb_pool[ARCMSR_MAX_FREECCB_NUM];
 	/* used for memory free */
