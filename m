From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v2 7/7] megaraid_sas: driver version upgrade
Date: Thu, 20 Oct 2016 02:05:05 -0700
Message-ID: <1476954305-576-8-git-send-email-sumit.saxena@broadcom.com>
References: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33390 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757595AbcJTJFe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 05:05:34 -0400
Received: by mail-pf0-f178.google.com with SMTP id 128so32895641pfz.0
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2016 02:05:34 -0700 (PDT)
In-Reply-To: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>

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
+#define MEGASAS_VERSION				"06.812.07.00-rc1"
+#define MEGASAS_RELDATE				"August 22, 2016"
 
 /*
  * Device IDs
-- 
1.8.3.1

