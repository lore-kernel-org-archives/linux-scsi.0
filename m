From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 12/21] lpfc: Revise NVME module parameter descriptions for better clarity
Date: Fri, 29 Sep 2017 17:34:38 -0700
Message-ID: <20170930003447.10747-13-jsmart2021@gmail.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34296 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752605AbdI3AfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 20:35:07 -0400
Received: by mail-qk0-f196.google.com with SMTP id d70so783002qkc.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2017 17:35:07 -0700 (PDT)
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

The descriptions for lpfc_xri_split and lpfc_enable_fc4_type were
poor. Revise for better understanding:
  lpfc_xri_split - Percentage of FCP XRI resources versus NVME
  lpfc_enable_fc4_type - Enable FC4 Protocol support - FCP / NVME

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f02269b46049..65886646a16f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3375,7 +3375,7 @@ LPFC_ATTR_R(nvmet_mrq,
  */
 LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_FCP,
 	    LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
-	    "Define fc4 type to register with fabric.");
+	    "Enable FC4 Protocol support - FCP / NVME");
 
 /*
  * lpfc_xri_split: Defines the division of XRI resources between SCSI and NVME
@@ -3391,7 +3391,7 @@ LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_FCP,
  * percentage will go to NVME.
  */
 LPFC_ATTR_R(xri_split, 50, 10, 90,
-	    "Division of XRI resources between SCSI and NVME");
+	    "Percentage of FCP XRI resources versus NVME");
 
 /*
 # lpfc_log_verbose: Only turn this flag on if you are willing to risk being
-- 
2.13.1
