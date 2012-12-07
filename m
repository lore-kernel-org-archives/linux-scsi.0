From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 4/6] qla2xxx: Allow ISP81xx to create ATIO queues.
Date: Fri,  7 Dec 2012 02:30:52 -0500
Message-ID: <1354865454-29964-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1354865454-29964-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:58706 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753470Ab2LGHtk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 02:49:40 -0500
In-Reply-To: <1354865454-29964-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 519e7b8..fd55841 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2425,6 +2425,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		req_length = REQUEST_ENTRY_CNT_24XX;
 		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->tgt.atio_q_length = ATIO_ENTRY_CNT_24XX;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
 		ha->gid_list_info_size = 8;
-- 
1.7.7

