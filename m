From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH v2 3/5] bnx2fc: Print netdev device name when FCoE is successfully initialized.
Date: Thu, 7 Apr 2016 09:07:58 -0400
Message-ID: <1460034480-28512-4-git-send-email-chad.dupuis@qlogic.com>
References: <1460034480-28512-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:44603 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752617AbcDGNtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2016 09:49:23 -0400
In-Reply-To: <1460034480-28512-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chad.dupuis@qlogic.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 365101a..a188199 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2039,6 +2039,8 @@ static void bnx2fc_ulp_init(struct cnic_dev *dev)
 		return;
 	}
 
+	pr_info(PFX "FCoE initialized for %s.\n", dev->netdev->name);
+
 	/* Add HBA to the adapter list */
 	mutex_lock(&bnx2fc_dev_lock);
 	list_add_tail(&hba->list, &adapter_list);
-- 
2.0.0.rc0.26.g779792a

