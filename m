From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 4/5] qla2xxx: Remove debug code that msleeps for random duration.
Date: Mon, 25 Mar 2013 02:21:39 -0400
Message-ID: <1364192500-17013-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1364192500-17013-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:38858 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755409Ab3CYGo0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 02:44:26 -0400
In-Reply-To: <1364192500-17013-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 1d82eef..b3db9dc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1938,11 +1938,6 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 		    "Timer for the VP[%d] has stopped\n", vha->vp_idx);
 	}
 
-	/* No pending activities shall be there on the vha now */
-	if (ql2xextended_error_logging & ql_dbg_user)
-		msleep(random32()%10);  /* Just to see if something falls on
-					* the net we have placed below */
-
 	BUG_ON(atomic_read(&vha->vref_count));
 
 	qla2x00_free_fcports(vha);
-- 
1.7.7

