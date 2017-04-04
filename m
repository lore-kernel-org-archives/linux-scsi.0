From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 09/19] Fix Kconfig defines.
Date: Tue,  4 Apr 2017 10:17:02 -0700
Message-ID: <1491326232-11255-10-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38163 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755151AbdDDRZl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:41 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 9B27330C0AA
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:45 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

One of the idefs in the previous kconfig patch was not corrected.
Also one alingment issue fixed.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 +-
 drivers/scsi/lpfc/lpfc_nvme.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 9e66cb0..0e28c2e 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3335,7 +3335,7 @@ LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_FCP,
  * percentage will go to NVME.
  */
 LPFC_ATTR_R(xri_split, 50, 10, 90,
-	     "Division of XRI resources between SCSI and NVME");
+	    "Division of XRI resources between SCSI and NVME");
 
 /*
 # lpfc_log_verbose: Only turn this flag on if you are willing to risk being
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 9726c95..9d39093 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2264,7 +2264,7 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 void
 lpfc_nvme_update_localport(struct lpfc_vport *vport)
 {
-#ifdef CONFIG_LPFC_NVME_INITIATOR
+#if (IS_ENABLED(CONFIG_NVME_FC))
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
 
-- 
2.1.0
