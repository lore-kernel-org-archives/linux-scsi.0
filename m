From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: lpfc: fix spelling mistake "entrys" -> "entries"
Date: Fri, 26 May 2017 11:11:37 +0100
Message-ID: <20170526101137.14282-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in debugfs message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 4bcb92c844ca..efd8a17ac2e5 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -323,7 +323,7 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hba *phba, char *buf, int size)
 	raw_index = phba->hbq_get[i];
 	getidx = le32_to_cpu(raw_index);
 	len +=  snprintf(buf+len, size-len,
-		"entrys:%d bufcnt:%d Put:%d nPut:%d localGet:%d hbaGet:%d\n",
+		"entries:%d bufcnt:%d Put:%d nPut:%d localGet:%d hbaGet:%d\n",
 		hbqs->entry_count, hbqs->buffer_count, hbqs->hbqPutIdx,
 		hbqs->next_hbqPutIdx, hbqs->local_hbqGetIdx, getidx);
 
-- 
2.11.0

