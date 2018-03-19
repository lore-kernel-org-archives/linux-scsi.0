From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: qla2xxx: fix spelling mistake: "existant" -> "existent"
Date: Mon, 19 Mar 2018 10:53:41 +0000
Message-ID: <20180319105341.487-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in debug message text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 245005f1e93e..e002dd61e110 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2023,7 +2023,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha, s_id);
 	if (!sess) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf012,
-		    "qla_target(%d): task abort for non-existant session\n",
+		    "qla_target(%d): task abort for non-existent session\n",
 		    vha->vp_idx);
 		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
-- 
2.15.1
