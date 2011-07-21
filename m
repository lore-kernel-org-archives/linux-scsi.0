From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 059/103] target: Remove unused var from transport_generic_do_tmr
Date: Thu, 21 Jul 2011 00:08:11 -0700
Message-ID: <1311232135-6653-60-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm1-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.94]:22540
	"HELO nm1-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751926Ab1GUHI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:29 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 33e5275..54fa0a4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5501,14 +5501,12 @@ void transport_send_task_abort(struct se_cmd *cmd)
  */
 int transport_generic_do_tmr(struct se_cmd *cmd)
 {
-	struct se_cmd *ref_cmd;
 	struct se_device *dev = cmd->se_dev;
 	struct se_tmr_req *tmr = cmd->se_tmr_req;
 	int ret;
 
 	switch (tmr->function) {
 	case TMR_ABORT_TASK:
-		ref_cmd = tmr->ref_cmd;
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
 	case TMR_ABORT_TASK_SET:
-- 
1.7.6

