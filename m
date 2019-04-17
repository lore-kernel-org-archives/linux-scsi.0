From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: qedi: fix spelling mistake "oflload" -> "offload"
Date: Wed, 17 Apr 2019 14:43:04 +0100
Message-ID: <20190417134304.10979-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a couple of spelling mistakes in some kernel alert messages.
Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 6d6d6013e35b..e4391ee2c27a 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -579,7 +579,7 @@ static int qedi_conn_start(struct iscsi_cls_conn *cls_conn)
 	rval = qedi_iscsi_update_conn(qedi, qedi_conn);
 	if (rval) {
 		iscsi_conn_printk(KERN_ALERT, conn,
-				  "conn_start: FW oflload conn failed.\n");
+				  "conn_start: FW offload conn failed.\n");
 		rval = -EINVAL;
 		goto start_err;
 	}
@@ -590,7 +590,7 @@ static int qedi_conn_start(struct iscsi_cls_conn *cls_conn)
 	rval = iscsi_conn_start(cls_conn);
 	if (rval) {
 		iscsi_conn_printk(KERN_ALERT, conn,
-				  "iscsi_conn_start: FW oflload conn failed!!\n");
+				  "iscsi_conn_start: FW offload conn failed!!\n");
 	}
 
 start_err:
-- 
2.20.1
