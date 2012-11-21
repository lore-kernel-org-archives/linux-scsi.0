From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 17/19] qla2xxx: Fix typo in qla2xxx driver.
Date: Wed, 21 Nov 2012 02:40:42 -0500
Message-ID: <1353483644-17262-18-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:65227 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753573Ab2KUH64 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:56 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
 drivers/scsi/qla2xxx/qla_nx.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e43b4d5..55ee3ba 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -251,7 +251,7 @@ qla2x00_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	/* Read all mbox registers? */
 	mboxes = (1 << ha->mbx_count) - 1;
 	if (!ha->mcp)
-		ql_dbg(ql_dbg_async, vha, 0x5001, "MBX pointer ERRROR.\n");
+		ql_dbg(ql_dbg_async, vha, 0x5001, "MBX pointer ERROR.\n");
 	else
 		mboxes = ha->mcp->in_mb;
 
@@ -2314,7 +2314,7 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	/* Read all mbox registers? */
 	mboxes = (1 << ha->mbx_count) - 1;
 	if (!ha->mcp)
-		ql_dbg(ql_dbg_async, vha, 0x504e, "MBX pointer ERRROR.\n");
+		ql_dbg(ql_dbg_async, vha, 0x504e, "MBX pointer ERROR.\n");
 	else
 		mboxes = ha->mcp->in_mb;
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index f0fdc22..45f6191 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -956,7 +956,7 @@ qla82xx_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 	}
 	if (loops >= 50000) {
 		ql_log(ql_log_fatal, vha, 0x00b9,
-		    "Failed to aquire SEM2 lock.\n");
+		    "Failed to acquire SEM2 lock.\n");
 		return -1;
 	}
 	ret = qla82xx_do_rom_fast_read(ha, addr, valp);
@@ -1123,7 +1123,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 		long data;
 	};
 
-	/* Halt all the indiviual PEGs and other blocks of the ISP */
+	/* Halt all the individual PEGs and other blocks of the ISP */
 	qla82xx_rom_lock(ha);
 
 	/* disable all I2Q */
-- 
1.7.7

