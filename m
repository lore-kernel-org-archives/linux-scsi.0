From: madhu.iyengar@qlogic.com
Subject: [PATCH 04/14] qla2xxx: Fixed zero test on new_config in qla2x00_process_loopback().
Date: Tue, 21 Dec 2010 16:00:17 -0800
Message-ID: <1292976027-12034-5-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36164 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753271Ab0LVADY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:24 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Fixed the incorrect zero test on array new_config[].

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 31a4121..6146d39 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -753,7 +753,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 			command_sent = INT_DEF_LB_LOOPBACK_CMD;
 			rval = qla2x00_loopback_test(vha, &elreq, response);
 
-			if (new_config[1]) {
+			if (new_config[0]) {
 				/* Revert back to original port config
 				 * Also clear internal loopback
 				 */
-- 
1.6.0.2

