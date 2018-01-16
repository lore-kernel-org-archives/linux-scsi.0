From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 7/8] qla2xxx: Add XCB counters to debugfs
Date: Mon, 15 Jan 2018 20:46:52 -0800
Message-ID: <20180116044653.20696-8-himanshu.madhani@cavium.com>
References: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0042.outbound.protection.outlook.com ([104.47.32.42]:19172
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751306AbeAPErK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jan 2018 23:47:10 -0500
In-Reply-To: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Anil Gurumurthy <anil.gurumurthy@cavium.com>

Signed-off-by: Anil Gurumurthy <anil.gurumurthy@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index ddb53db61fd2..0b190082aa8d 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -143,6 +143,15 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 		seq_printf(s, "Current IOCB count[%d]\n", mb[10]);
 		seq_printf(s, "MAX VP count[%d]\n", mb[11]);
 		seq_printf(s, "MAX FCF count[%d]\n", mb[12]);
+		seq_printf(s, "Current free pageable XCB buffer cnt[%d]\n",
+		    mb[20]);
+		seq_printf(s, "Original Initiator fast XCB buffer cnt[%d]\n",
+		    mb[21]);
+		seq_printf(s, "Current free Initiator fast XCB buffer cnt[%d]\n",
+		    mb[22]);
+		seq_printf(s, "Original Target fast XCB buffer cnt[%d]\n",
+		    mb[23]);
+
 	}
 
 	return 0;
-- 
2.12.0
