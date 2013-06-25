From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 12/16] qla2xxx: Remove redundant assignments.
Date: Tue, 25 Jun 2013 11:27:27 -0400
Message-ID: <1372174051-4211-13-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:37191
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288Ab3FYPyB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:54:01 -0400
Received: from mail9-co9 (localhost [127.0.0.1])	by mail9-co9-R.bigfish.com
 (Postfix) with ESMTP id E2760C40466	for <linux-scsi@vger.kernel.org>; Tue, 25
 Jun 2013 15:54:00 +0000 (UTC)
Received: from CO9EHSMHS026.bigfish.com (unknown [10.236.132.231])	by
 mail9-co9.bigfish.com (Postfix) with ESMTP id 13F7CAC0053	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:51 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

The value of the pointer called "nxt" is not used after the
"nxt = qla24xx_copy_eft(ha, nxt)" statement. Hence keep the function
call but remove the assignment.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 91dbd81..df132fe 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1470,7 +1470,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	nxt = qla2xxx_copy_queues(ha, nxt);
 
-	nxt = qla24xx_copy_eft(ha, nxt);
+	qla24xx_copy_eft(ha, nxt);
 
 	/* Chain entries -- started with MQ. */
 	nxt_chain = qla25xx_copy_fce(ha, nxt_chain, &last_chain);
@@ -1789,7 +1789,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	nxt = qla2xxx_copy_queues(ha, nxt);
 
-	nxt = qla24xx_copy_eft(ha, nxt);
+	qla24xx_copy_eft(ha, nxt);
 
 	/* Chain entries -- started with MQ. */
 	nxt_chain = qla25xx_copy_fce(ha, nxt_chain, &last_chain);
@@ -2291,7 +2291,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 copy_queue:
 	nxt = qla2xxx_copy_queues(ha, nxt);
 
-	nxt = qla24xx_copy_eft(ha, nxt);
+	qla24xx_copy_eft(ha, nxt);
 
 	/* Chain entries -- started with MQ. */
 	nxt_chain = qla25xx_copy_fce(ha, nxt_chain, &last_chain);
-- 
1.7.7


