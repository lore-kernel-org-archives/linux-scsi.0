From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 4/4] megaraid_sas: Driver version upgrade
Date: Fri, 10 Mar 2017 03:22:15 -0800
Message-ID: <1489144935-26567-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1489144935-26567-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:32839 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934219AbdCJLW6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2017 06:22:58 -0500
Received: by mail-pf0-f180.google.com with SMTP id w189so40970164pfb.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2017 03:22:57 -0800 (PST)
In-Reply-To: <1489144935-26567-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index e7e5974..2b209bb 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"07.701.16.00-rc1"
-#define MEGASAS_RELDATE				"February 2, 2017"
+#define MEGASAS_VERSION				"07.701.17.00-rc1"
+#define MEGASAS_RELDATE				"March 2, 2017"
 
 /*
  * Device IDs
-- 
2.8.3
