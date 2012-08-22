From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 24/42] qla2xxx: Ensure PLOGI is sent to Fabric Management-Server upon request.
Date: Wed, 22 Aug 2012 14:21:18 -0400
Message-ID: <1345659696-3670-25-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:35225 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964995Ab2HVSiZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:25 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index ddd2a9d..f4e4bd7 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1131,7 +1131,7 @@ qla2x00_mgmt_svr_login(scsi_qla_host_t *vha)
 		return ret;
 
 	rval = ha->isp_ops->fabric_login(vha, vha->mgmt_svr_loop_id, 0xff, 0xff,
-	    0xfa, mb, BIT_1|BIT_0);
+	    0xfa, mb, BIT_1);
 	if (rval != QLA_SUCCESS || mb[0] != MBS_COMMAND_COMPLETE) {
 		if (rval == QLA_MEMORY_ALLOC_FAILED)
 			ql_dbg(ql_dbg_disc, vha, 0x2085,
-- 
1.7.7

