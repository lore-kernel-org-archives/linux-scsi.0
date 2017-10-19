From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 19/19] megaraid_sas: driver version upgrade
Date: Thu, 19 Oct 2017 02:49:06 -0700
Message-ID: <1508406546-25944-20-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:43633 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752600AbdJSJut (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:49 -0400
Received: by mail-pg0-f67.google.com with SMTP id s75so6765972pgs.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:49 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index b34fc68c14c9..f5a36ccb8606 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"07.702.06.00-rc1"
-#define MEGASAS_RELDATE				"June 21, 2017"
+#define MEGASAS_VERSION				"07.703.05.00-rc1"
+#define MEGASAS_RELDATE				"October 5, 2017"
 
 /*
  * Device IDs
-- 
2.14.1.dirty
