From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH V2 13/20] qla2xxx: Remove ISP_ABORT_NEEDED and ISP_ABORT_RETRY checks from watchdog function for ISP8044.
Date: Mon, 16 Dec 2013 22:28:36 -0500
Message-ID: <1387250923-1041-14-git-send-email-saurav.kashyap@qlogic.com>
References: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:6773 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649Ab3LQEBi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 23:01:38 -0500
In-Reply-To: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Atul Deshmukh <atul.deshmukh@qlogic.com>

Signed-off-by: Atul Deshmukh <atul.deshmukh@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index eda7787..0350a59 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -2014,8 +2014,6 @@ qla8044_watchdog(struct scsi_qla_host *vha)
 
 	/* don't poll if reset is going on or FW hang in quiescent state */
 	if (!(test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
-	    test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
-	    test_bit(ISP_ABORT_RETRY, &vha->dpc_flags) ||
 	    test_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags))) {
 		dev_state = qla8044_rd_direct(vha, QLA8044_CRB_DEV_STATE_INDEX);
 
-- 
1.7.7

