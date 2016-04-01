From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 3/5] bnx2fc: Print netdev device name when FCoE is successfully initialized.
Date: Fri, 1 Apr 2016 09:10:21 -0400
Message-ID: <1459516223-32106-4-git-send-email-chad.dupuis@qlogic.com>
References: <1459516223-32106-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:38234 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756150AbcDANvf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2016 09:51:35 -0400
In-Reply-To: <1459516223-32106-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chad.dupuis@qlogic.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index d95eee6..60423cf 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2044,6 +2044,8 @@ static void bnx2fc_ulp_init(struct cnic_dev *dev)
 		return;
 	}
 
+	pr_err(PFX "FCoE initialized for %s.\n", dev->netdev->name);
+
 	/* Add HBA to the adapter list */
 	mutex_lock(&bnx2fc_dev_lock);
 	list_add_tail(&hba->list, &adapter_list);
-- 
2.0.0.rc0.26.g779792a

