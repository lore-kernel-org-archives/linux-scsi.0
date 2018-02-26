From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH] scsi: core: fix two wrong indentation cases
Date: Mon, 26 Feb 2018 15:59:16 +0800
Message-ID: <1519631956-1775-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

No functional changes. Just fix two wrong indentation cases in
scsi_finish_command and scsi_decide_disposition.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 drivers/scsi/scsi.c       | 2 +-
 drivers/scsi/scsi_error.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a7e4fba..4c60c26 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -231,7 +231,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"(result %x)\n", cmd->result));
 
 	good_bytes = scsi_bufflen(cmd);
-        if (!blk_rq_is_passthrough(cmd->request)) {
+	if (!blk_rq_is_passthrough(cmd->request)) {
 		int old_good_bytes = good_bytes;
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d042915..96066d1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1888,7 +1888,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	}
 	return FAILED;
 
-      maybe_retry:
+maybe_retry:
 
 	/* we requeue for retry because the error was retryable, and
 	 * the request was not marked fast fail.  Note that above,
-- 
2.7.4
