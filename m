From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] libata: make ata_sg_clean static over again
Date: Fri, 10 Mar 2017 10:05:40 +0800
Message-ID: <1489111540-22046-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, tj@kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: miaoxie@huawei.com, Jason Yan <yanaijie@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fixes the following sparse warning:

drivers/ata/libata-core.c:4913:6: warning: symbol 'ata_sg_clean' was not
declared. Should it be static?

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ca75823..5d33699 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4910,7 +4910,7 @@ void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-void ata_sg_clean(struct ata_queued_cmd *qc)
+static void ata_sg_clean(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg = qc->sg;
-- 
2.5.0

