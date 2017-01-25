From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 02/24] aacraid: Added aacraid.h include guard
Date: Wed, 25 Jan 2017 10:00:49 -0800
Message-ID: <20170125180111.25401-3-RaghavaAditya.Renukunta@microsemi.com>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0040.outbound.protection.outlook.com ([104.47.38.40]:39424
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751866AbdAZAiA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 19:38:00 -0500
In-Reply-To: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Benesh@microsemi.com

Added aacraid.h include guard

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>

---
 Changes in  V2:
   None

 drivers/scsi/aacraid/aacraid.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index f059c14..01b457b 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1,3 +1,5 @@
+#ifndef _AACRAID_H_
+#define _AACRAID_H_
 #ifndef dprintk
 # define dprintk(x)
 #endif
@@ -2194,3 +2196,4 @@ extern int aac_commit;
 extern int update_interval;
 extern int check_interval;
 extern int aac_check_reset;
+#endif
-- 
2.7.4

