From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 3/6] qla2xxx: Remove unused symbols
Date: Tue, 23 Jan 2018 16:33:48 -0800
Message-ID: <20180124003351.2616-4-bart.vanassche@wdc.com>
References: <20180124003351.2616-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:18101 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752736AbeAXAdw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 19:33:52 -0500
In-Reply-To: <20180124003351.2616-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Remove a few preprocessor macros that are not used anywhere.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_nx2.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.h b/drivers/scsi/qla2xxx/qla_nx2.h
index 83c1b7e17c80..8ba7c1db07c3 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.h
+++ b/drivers/scsi/qla2xxx/qla_nx2.h
@@ -23,10 +23,6 @@
 #define MD_MIU_TEST_AGT_WRDATA_HI		0x410000A4
 #define MD_MIU_TEST_AGT_WRDATA_ULO		0x410000B0
 #define MD_MIU_TEST_AGT_WRDATA_UHI		0x410000B4
-#define MD_MIU_TEST_AGT_RDDATA_LO		0x410000A8
-#define MD_MIU_TEST_AGT_RDDATA_HI		0x410000AC
-#define MD_MIU_TEST_AGT_RDDATA_ULO		0x410000B8
-#define MD_MIU_TEST_AGT_RDDATA_UHI		0x410000BC
 
 /* MIU_TEST_AGT_CTRL flags. work for SIU as well */
 #define MIU_TA_CTL_WRITE_ENABLE	(MIU_TA_CTL_WRITE | MIU_TA_CTL_ENABLE)
-- 
2.15.1
