From: Joe Perches <joe@perches.com>
Subject: [PATCH 09/12] [SCSI] qla4xxx: Use DECLARE_BITMAP
Date: Tue, 19 May 2015 18:37:57 -0700
Message-ID: <44ce82fdac72ad8bf9fe572bc532392faddf9eac.1432085659.git.joe@perches.com>
References: <cover.1432085659.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1432085659.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the generic mechanism to declare a bitmap instead of unsigned long.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/qla4xxx/ql4_def.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 8f6d0fb..32341ac 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -795,7 +795,7 @@ struct scsi_qla_host {
 
 #define CHAP_DMA_BLOCK_SIZE    512
 	struct workqueue_struct *task_wq;
-	unsigned long ddb_idx_map[MAX_DDB_ENTRIES / BITS_PER_LONG];
+	DECLARE_BITMAP(ddb_idx_map, MAX_DDB_ENTRIES);
 #define SYSFS_FLAG_FW_SEL_BOOT 2
 	struct iscsi_boot_kset *boot_kset;
 	struct ql4_boot_tgt_info boot_tgt;
-- 
2.1.2
