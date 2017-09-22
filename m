From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 11/19] lpfc: Revise NVME module parameter descriptions for better clarity
Date: Thu, 21 Sep 2017 23:17:33 -0700
Message-ID: <20170922061741.12347-12-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36342 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdIVGSH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:07 -0400
Received: by mail-pf0-f193.google.com with SMTP id f84so88317pfj.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:06 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
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
---
 drivers/scsi/lpfc/lpfc_attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index dc6519b2c53a..4dcd129ca901 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3377,7 +3377,7 @@ LPFC_ATTR_R(nvmet_mrq,
  */
 LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_FCP,
 	    LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
-	    "Define fc4 type to register with fabric.");
+	    "Enable FC4 Protocol support - FCP / NVME");
 
 /*
  * lpfc_xri_split: Defines the division of XRI resources between SCSI and NVME
@@ -3393,7 +3393,7 @@ LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_FCP,
  * percentage will go to NVME.
  */
 LPFC_ATTR_R(xri_split, 50, 10, 90,
-	    "Division of XRI resources between SCSI and NVME");
+	    "Percentage of FCP XRI resources versus NVME");
 
 /*
 # lpfc_log_verbose: Only turn this flag on if you are willing to risk being
-- 
2.13.1
