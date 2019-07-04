From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Subject: [PATCH] scsi: Remove unreachable code
Date: Thu,  4 Jul 2019 17:55:56 +0800
Message-ID: <1562234156-11945-1-git-send-email-dingxiang@cmss.chinamobile.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The return code after switch default is unreachable,
so remove it.

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
---
 drivers/scsi/scsi_error.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index bfa569f..12180f0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1909,7 +1909,6 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	default:
 		return FAILED;
 	}
-	return FAILED;
 
 maybe_retry:
 
-- 
1.9.1
