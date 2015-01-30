From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH 6/6] pm80xx : corrected linkrate value.
Date: Fri, 30 Jan 2015 11:36:45 +0530
Message-ID: <20150130060645.23653-7-Viswas.G@microsemi.com>
References: <20150130060645.23653-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02hn0224.outbound.protection.outlook.com ([104.47.37.224]:62784
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755872AbdHYRMT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 13:12:19 -0400
In-Reply-To: <20150130060645.23653-1-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com

Corrected the value defined for LINKRATE_60 (6 Gig).

Signed-off-by: Raj Dinesh <Raj.Dinesh@microsemi.com>
Signed-off-by: Viswas G <viswas.g@microsemi.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index d8e5d81e83f1..71dee83aeef0 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -167,7 +167,7 @@
 #define LINKMODE_AUTO			(0x03 << 12)
 #define LINKRATE_15			(0x01 << 8)
 #define LINKRATE_30			(0x02 << 8)
-#define LINKRATE_60			(0x06 << 8)
+#define LINKRATE_60			(0x04 << 8)
 #define LINKRATE_120			(0x08 << 8)
 
 /* phy_profile */
-- 
2.12.3
