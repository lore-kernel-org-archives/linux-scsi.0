From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 06/22] qla2xxx: Change "Done" to "Entering" in the debug print statement in qla2x00_port_logout.
Date: Tue, 15 May 2012 14:34:13 -0400
Message-ID: <1337106869-14191-7-git-send-email-chad.dupuis@qlogic.com>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:45336 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966442Ab2EOS5s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:48 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 54eba10..10244ba 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4549,7 +4549,7 @@ qla2x00_port_logout(scsi_qla_host_t *vha, struct fc_port *fcport)
 	}
 
 
-	ql_dbg(ql_dbg_mbx, vha, 0x113c, "Done %s.\n",  __func__);
+	ql_dbg(ql_dbg_mbx, vha, 0x113c, "Entering %s.\n",  __func__);
 
 	/* Perform Implicit LOGO. */
 	mcp->mb[0] = MBC_PORT_LOGOUT;
-- 
1.7.7

