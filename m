From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 34/42] qla2xxx: Enable fw attributes for ISP24xx and above.
Date: Wed, 22 Aug 2012 14:21:28 -0400
Message-ID: <1345659696-3670-35-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:13068 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S965011Ab2HVSig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:36 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3d35024..18c509f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -533,7 +533,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 	mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	if (IS_QLA81XX(vha->hw) || IS_QLA8031(ha))
 		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10|MBX_9|MBX_8;
-	if (IS_QLA83XX(vha->hw))
+	if (IS_FWI2_CAPABLE(ha))
 		mcp->in_mb |= MBX_17|MBX_16|MBX_15;
 	mcp->flags = 0;
 	mcp->tov = MBX_TOV_SECONDS;
-- 
1.7.7

