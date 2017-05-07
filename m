From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 19/19] aacraid: Update driver version to 50834
Date: Sun, 7 May 2017 06:34:24 -0700
Message-ID: <1494164064-17715-20-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0088.outbound.protection.outlook.com ([104.47.41.88]:16928
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751577AbdEHIG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 May 2017 04:06:57 -0400
In-Reply-To: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

Update the driver version to 50834

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 58ccd2a..0995265 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -97,7 +97,7 @@ enum {
 #define	PMC_GLOBAL_INT_BIT0		0x00000001
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 50792
+# define AAC_DRIVER_BUILD 50834
 # define AAC_DRIVER_BRANCH "-custom"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
-- 
2.7.4
