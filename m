From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 1/2] tcm_qla2xxx: tcm_qla2xxx_handle_tmr() can be static
Date: Mon, 11 Jun 2012 18:31:30 -0700
Message-ID: <1339464691-25829-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:35147 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752913Ab2FLBbg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jun 2012 21:31:36 -0400
Received: by pbbrp16 with SMTP id rp16so56966pbb.10
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jun 2012 18:31:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arun Easi <arun.easi@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 436598f..446297a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -652,8 +652,8 @@ static int tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 /*
  * Called from qla_target.c:qlt_issue_task_mgmt()
  */
-int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
-			uint8_t tmr_func, uint32_t tag)
+static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
+	uint8_t tmr_func, uint32_t tag)
 {
 	struct qla_tgt_sess *sess = mcmd->sess;
 	struct se_cmd *se_cmd = &mcmd->se_cmd;
-- 
1.7.9.5

