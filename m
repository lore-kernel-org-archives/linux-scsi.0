From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 12/35] qla2xxx: Incorrect debug level on mailbox command print 0x1111.
Date: Thu, 25 Sep 2014 05:16:43 -0400
Message-ID: <1411636626-7566-13-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:49834 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbaIYJvQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:16 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a7a373f..ca7f4f0 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -117,7 +117,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	command = mcp->mb[0];
 	mboxes = mcp->out_mb;
 
-	ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1111,
+	ql_dbg(ql_dbg_mbx, vha, 0x1111,
 	    "Mailbox registers (OUT):\n");
 	for (cnt = 0; cnt < ha->mbx_count; cnt++) {
 		if (IS_QLA2200(ha) && cnt == 8)
-- 
1.7.7

