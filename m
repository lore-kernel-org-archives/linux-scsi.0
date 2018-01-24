From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 4/6] qla4xxx: Remove unused symbols
Date: Tue, 23 Jan 2018 16:33:49 -0800
Message-ID: <20180124003351.2616-5-bart.vanassche@wdc.com>
References: <20180124003351.2616-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51749 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbeAXAdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 19:33:53 -0500
In-Reply-To: <20180124003351.2616-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Remove a few preprocessor macros that are not used anywhere.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla4xxx/ql4_nx.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index 337d9fcf6417..2c098cf9a1ac 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -1022,11 +1022,6 @@ struct qla8xxx_minidump_entry_queue {
 #define MD_MIU_TEST_AGT_WRDATA_ULO		0x410000B0
 #define MD_MIU_TEST_AGT_WRDATA_UHI		0x410000B4
 
-#define MD_MIU_TEST_AGT_RDDATA_LO		0x410000A8
-#define MD_MIU_TEST_AGT_RDDATA_HI		0x410000AC
-#define MD_MIU_TEST_AGT_RDDATA_ULO		0x410000B8
-#define MD_MIU_TEST_AGT_RDDATA_UHI		0x410000BC
-
 static const int MD_MIU_TEST_AGT_RDDATA[] = { 0x410000A8,
 				0x410000AC, 0x410000B8, 0x410000BC };
 #endif
-- 
2.15.1
