From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 5/7] megaraid_sas: driver version upgrade
Date: Mon, 17 Oct 2016 03:24:08 -0700
Message-ID: <1476699850-25083-6-git-send-email-sumit.saxena@broadcom.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33782 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932335AbcJQKcu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 06:32:50 -0400
Received: by mail-pf0-f182.google.com with SMTP id 128so78521332pfz.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 03:32:50 -0700 (PDT)
In-Reply-To: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>

Upgrade driver version.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 43fd14f..1d4de90 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.811.02.00-rc1"
-#define MEGASAS_RELDATE				"April 12, 2016"
+#define MEGASAS_VERSION				"06.812.06.00-rc1"
+#define MEGASAS_RELDATE				"August 22, 2016"
 
 /*
  * Device IDs
-- 
1.8.3.1

