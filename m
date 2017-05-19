From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH 5/7] qedi: Set firmware tcp msl timer value.
Date: Fri, 19 May 2017 01:33:19 -0700
Message-ID: <20170519083321.18030-6-manish.rangankar@cavium.com>
References: <20170519083321.18030-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0047.outbound.protection.outlook.com ([104.47.41.47]:63306
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751329AbdESIdo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 04:33:44 -0400
In-Reply-To: <20170519083321.18030-1-manish.rangankar@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qedi/qedi_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 997e305..62ba0550 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -827,6 +827,7 @@ static int qedi_set_iscsi_pf_param(struct qedi_ctx *qedi)
 	qedi->pf_params.iscsi_pf_params.num_uhq_pages_in_ring = num_sq_pages;
 	qedi->pf_params.iscsi_pf_params.num_queues = qedi->num_queues;
 	qedi->pf_params.iscsi_pf_params.debug_mode = qedi_fw_debug;
+	qedi->pf_params.iscsi_pf_params.two_msl_timer = 4000;
 
 	for (log_page_size = 0 ; log_page_size < 32 ; log_page_size++) {
 		if ((1 << log_page_size) == PAGE_SIZE)
-- 
1.8.3.1
