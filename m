From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 15/15] megaraid_sas: driver version upgrade
Date: Fri, 30 Jun 2017 01:30:09 -0700
Message-ID: <1498811409-11157-16-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:34156 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbdF3Ibh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2017 04:31:37 -0400
Received: by mail-pg0-f44.google.com with SMTP id t186so60734640pgb.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2017 01:31:37 -0700 (PDT)
In-Reply-To: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 6d9f111..a6722c9 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"07.701.17.00-rc1"
-#define MEGASAS_RELDATE				"March 2, 2017"
+#define MEGASAS_VERSION				"07.702.06.00-rc1"
+#define MEGASAS_RELDATE				"June 21, 2017"
 
 /*
  * Device IDs
-- 
2.8.3
