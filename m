From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 12/14] lpfc: Revise strings with full lpfc parameter name
Date: Thu, 11 Aug 2016 11:35:59 -0700
Message-ID: <57acc58f.dg+1TtiJMN9LvPib%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34760 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbcHKSgC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:36:02 -0400
Received: by mail-qk0-f182.google.com with SMTP id p186so4258005qkd.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:36:02 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id v60sm2219387qtd.22.2016.08.11.11.36.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:36:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Revise strings with full lpfc parameter name

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 1b6090c..3740e5d 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2877,9 +2877,9 @@ lpfc_nodev_tmo_init(struct lpfc_vport *vport, int val)
 		vport->cfg_nodev_tmo = vport->cfg_devloss_tmo;
 		if (val != LPFC_DEF_DEVLOSS_TMO)
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "0407 Ignoring nodev_tmo module "
-					 "parameter because devloss_tmo is "
-					 "set.\n");
+					 "0407 Ignoring lpfc_nodev_tmo module "
+					 "parameter because lpfc_devloss_tmo "
+					 "is set.\n");
 		return 0;
 	}
 
@@ -2938,8 +2938,8 @@ lpfc_nodev_tmo_set(struct lpfc_vport *vport, int val)
 	if (vport->dev_loss_tmo_changed ||
 	    (lpfc_devloss_tmo != LPFC_DEF_DEVLOSS_TMO)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				 "0401 Ignoring change to nodev_tmo "
-				 "because devloss_tmo is set.\n");
+				 "0401 Ignoring change to lpfc_nodev_tmo "
+				 "because lpfc_devloss_tmo is set.\n");
 		return 0;
 	}
 	if (val >= LPFC_MIN_DEVLOSS_TMO && val <= LPFC_MAX_DEVLOSS_TMO) {
@@ -2954,7 +2954,7 @@ lpfc_nodev_tmo_set(struct lpfc_vport *vport, int val)
 		return 0;
 	}
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-			 "0403 lpfc_nodev_tmo attribute cannot be set to"
+			 "0403 lpfc_nodev_tmo attribute cannot be set to "
 			 "%d, allowed range is [%d, %d]\n",
 			 val, LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO);
 	return -EINVAL;
@@ -3005,8 +3005,8 @@ lpfc_devloss_tmo_set(struct lpfc_vport *vport, int val)
 	}
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-			 "0404 lpfc_devloss_tmo attribute cannot be set to"
-			 " %d, allowed range is [%d, %d]\n",
+			 "0404 lpfc_devloss_tmo attribute cannot be set to "
+			 "%d, allowed range is [%d, %d]\n",
 			 val, LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO);
 	return -EINVAL;
 }
@@ -4174,7 +4174,8 @@ lpfc_fcp_imax_init(struct lpfc_hba *phba, int val)
 	}
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"3016 fcp_imax: %d out of range, using default\n", val);
+			"3016 lpfc_fcp_imax: %d out of range, using default\n",
+			val);
 	phba->cfg_fcp_imax = LPFC_DEF_IMAX;
 
 	return 0;
@@ -4324,8 +4325,8 @@ lpfc_fcp_cpu_map_init(struct lpfc_hba *phba, int val)
 	}
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"3326 fcp_cpu_map: %d out of range, using default\n",
-			val);
+			"3326 lpfc_fcp_cpu_map: %d out of range, using "
+			"default\n", val);
 	phba->cfg_fcp_cpu_map = LPFC_DRIVER_CPU_MAP;
 
 	return 0;
-- 
2.5.0

