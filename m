From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH V2 9/9] pm80xx : corrected linkrate value.
Date: Wed, 18 Feb 2015 05:06:50 +0530
Message-ID: <20150217233650.9091-10-Viswas.G@microsemi.com>
References: <20150217233650.9091-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01hn0223.outbound.protection.outlook.com ([104.47.32.223]:18432
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752309AbdIMKmZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Sep 2017 06:42:25 -0400
In-Reply-To: <20150217233650.9091-1-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, jinpu.wang@profitbricks.com, martin.petersen@oracle.com

Corrected the value defined for LINKRATE_60 (6 Gig).

Signed-off-by: Raj Dinesh <Raj.Dinesh@microsemi.com>
Signed-off-by: Viswas G <viswas.g@microsemi.com>
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index e36c5176f9a9..889e69ce3689 100644
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
