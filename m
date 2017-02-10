From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 39/39] megaraid_sas: driver version upgrade
Date: Fri, 10 Feb 2017 00:59:39 -0800
Message-ID: <1486717179-23320-40-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:35536 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdBJJN4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 04:13:56 -0500
Received: by mail-pf0-f174.google.com with SMTP id 202so4933813pfx.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 01:12:22 -0800 (PST)
In-Reply-To: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 8c06cbf..e7e5974 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"07.700.00.00-rc1"
-#define MEGASAS_RELDATE				"November 29, 2016"
+#define MEGASAS_VERSION				"07.701.16.00-rc1"
+#define MEGASAS_RELDATE				"February 2, 2017"
 
 /*
  * Device IDs
-- 
2.8.3
