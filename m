From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 17/24] qla4xxx: Remove unused code from qla4xxx_set_ifcb()
Date: Mon, 16 Dec 2013 06:49:47 -0500
Message-ID: <1387194594-29817-18-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:19083 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754327Ab3LPMXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:39 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Removing unused code as FW does not need any value in mbox-5.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index cc27d7f..782a94586 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -383,7 +383,6 @@ qla4xxx_set_ifcb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 	mbox_cmd[2] = LSDW(init_fw_cb_dma);
 	mbox_cmd[3] = MSDW(init_fw_cb_dma);
 	mbox_cmd[4] = sizeof(struct addr_ctrl_blk);
-	mbox_cmd[5] = (IFCB_VER_MAX << 8) | IFCB_VER_MIN;
 
 	if (qla4xxx_mailbox_command(ha, 6, 6, mbox_cmd, mbox_sts) !=
 	    QLA_SUCCESS) {
-- 
1.8.2.GIT

