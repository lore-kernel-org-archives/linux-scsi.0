From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH 1/2] qedi: Remove WARN_ON for untracked cleanup.
Date: Thu, 15 Jun 2017 00:10:39 -0700
Message-ID: <20170615071040.18093-2-manish.rangankar@cavium.com>
References: <20170615071040.18093-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0063.outbound.protection.outlook.com ([104.47.38.63]:23765
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751761AbdFOHKv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Jun 2017 03:10:51 -0400
In-Reply-To: <20170615071040.18093-1-manish.rangankar@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qedi/qedi_fw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 8bc7ee1..507512c 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -870,7 +870,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x, task=%p\n",
 			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id, task);
-		WARN_ON(1);
 	}
 }
 
-- 
1.8.3.1
