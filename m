From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v3 8/8] megaraid_sas: driver version upgrade
Date: Fri, 21 Oct 2016 06:33:36 -0700
Message-ID: <1477056816-7058-9-git-send-email-kashyap.desai@broadcom.com>
References: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35480 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933402AbcJUNec (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2016 09:34:32 -0400
Received: by mail-pf0-f173.google.com with SMTP id s8so57270422pfj.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2016 06:34:32 -0700 (PDT)
In-Reply-To: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 43fd14f..74c7b44 100644
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
2.4.11

