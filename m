From: Colin King <colin.king@canonical.com>
Subject: [PATCH] qla4xxx: fix spelling mistake: "Tempalate" -> "Template"
Date: Tue, 25 Apr 2017 22:37:10 +0100
Message-ID: <20170425213710.20588-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in DEBUG2 debug message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla4xxx/ql4_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 4180d6d9fe78..5d6d158bbfd6 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -389,7 +389,7 @@ void qla4xxx_alloc_fw_dump(struct scsi_qla_host *ha)
 		goto alloc_cleanup;
 
 	DEBUG2(ql4_printk(KERN_INFO, ha,
-			  "Minidump Tempalate Size = 0x%x KB\n",
+			  "Minidump Template Size = 0x%x KB\n",
 			  ha->fw_dump_tmplt_size));
 	DEBUG2(ql4_printk(KERN_INFO, ha,
 			  "Total Minidump size = 0x%x KB\n", ha->fw_dump_size));
-- 
2.11.0
