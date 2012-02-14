From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] scsi: Fix typo in mv_sas.c
Date: Tue, 14 Feb 2012 23:49:12 +0900
Message-ID: <1329230952-2201-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
List-Id: linux-scsi@vger.kernel.org

Correct spelling "internel" to "internal" in
drivers/scsi/mvsas/mv_sas.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/mvsas/mv_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a4884a5..1c910c7 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1411,7 +1411,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 
 		if (res) {
 			del_timer(&task->timer);
-			mv_printk("executing internel task failed:%d\n", res);
+			mv_printk("executing internal task failed:%d\n", res);
 			goto ex_err;
 		}
 
-- 
1.7.6.5
