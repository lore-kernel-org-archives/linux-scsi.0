From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 03/22] qla2xxx: Fix typo in qla_mbx.c
Date: Tue, 15 May 2012 14:34:10 -0400
Message-ID: <1337106869-14191-4-git-send-email-chad.dupuis@qlogic.com>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:12520 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966430Ab2EOS52 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:28 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>

Correct spelling "occured" to "occurred" in
drivers/scsi/qla2xxx/qla_mbx.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b4a2339..54eba10 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -320,7 +320,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 					    CRB_NIU_XG_PAUSE_CTL_P1);
 				}
 				ql_log(ql_log_info, base_vha, 0x101c,
-				    "Mailbox cmd timeout occured, cmd=0x%x, "
+				    "Mailbox cmd timeout occurred, cmd=0x%x, "
 				    "mb[0]=0x%x, eeh_busy=0x%x. Scheduling ISP "
 				    "abort.\n", command, mcp->mb[0],
 				    ha->flags.eeh_busy);
@@ -345,7 +345,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 					    CRB_NIU_XG_PAUSE_CTL_P1);
 				}
 				ql_log(ql_log_info, base_vha, 0x101e,
-				    "Mailbox cmd timeout occured, cmd=0x%x, "
+				    "Mailbox cmd timeout occurred, cmd=0x%x, "
 				    "mb[0]=0x%x. Scheduling ISP abort ",
 				    command, mcp->mb[0]);
 				set_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
-- 
1.7.7

