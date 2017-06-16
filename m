From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 02/11] Fix nvme_info sysfs output to be consistent
Date: Thu, 15 Jun 2017 22:56:42 -0700
Message-ID: <20170616055651.9674-3-jsmart2021@gmail.com>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:32994 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbdFPF5F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 01:57:05 -0400
Received: by mail-qt0-f193.google.com with SMTP id w1so7898841qtg.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2017 22:57:05 -0700 (PDT)
In-Reply-To: <20170616055651.9674-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

First line of nvme_info output is not consistent

There is an Extra colon in the format.

First line of output will contain one of the following strings:
NVME Initiator Enabled
NVME Target Enabled
NVME Disabled

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 66269e342c7e..af22602b1058 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -171,7 +171,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		else
 			statep = "INIT";
 		len += snprintf(buf + len, PAGE_SIZE - len,
-				"NVME Target: Enabled  State %s\n",
+				"NVME Target Enabled  State %s\n",
 				statep);
 		len += snprintf(buf + len, PAGE_SIZE - len,
 				"%s%d WWPN x%llx WWNN x%llx DID x%06x\n",
-- 
2.11.0
