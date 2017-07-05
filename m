From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 15/15] megaraid_sas: driver version upgrade
Date: Wed,  5 Jul 2017 05:00:29 -0700
Message-ID: <1499256029-16319-16-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:34675 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752495AbdGEMCD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 08:02:03 -0400
Received: by mail-pg0-f45.google.com with SMTP id t186so123958907pgb.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 05:02:02 -0700 (PDT)
In-Reply-To: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
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
1.8.3.1
