From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 12/17 v2] lpfc: Revise strings with full lpfc parameter
 name
Date: Wed, 12 Oct 2016 13:14:15 -0700
Message-ID: <57fe9997.SnXhmZmY0iqAlcH+%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bastion.smtp.avagotech.com ([202.86.248.61]:53790 "EHLO
        sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934018AbcJLUOr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2016 16:14:47 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp1.avagotech.com (Postfix) with SMTP id 91B62100704
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 13:14:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Revise strings with full lpfc parameter name

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
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


