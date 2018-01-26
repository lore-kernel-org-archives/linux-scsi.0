From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 15/19] lpfc: Fix header inclusion in lpfc_nvmet
Date: Fri, 26 Jan 2018 11:22:35 -0800
Message-ID: <20180126192239.10727-16-jsmart2021@gmail.com>
References: <20180126192239.10727-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:41633 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752876AbeAZTXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2018 14:23:11 -0500
Received: by mail-qt0-f196.google.com with SMTP id i1so3960320qtj.8
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2018 11:23:10 -0800 (PST)
In-Reply-To: <20180126192239.10727-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The driver was inappropriately pulling in the nvme host's
nvme.h header. What it really needed was the standard
<linux/nvme.h> header.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 6dd8535918f6..823b6df0aec7 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -36,7 +36,7 @@
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/fc/fc_fs.h>
 
-#include <../drivers/nvme/host/nvme.h>
+#include <linux/nvme.h>
 #include <linux/nvme-fc-driver.h>
 #include <linux/nvme-fc.h>
 
-- 
2.13.1
