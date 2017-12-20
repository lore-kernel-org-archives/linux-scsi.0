From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 36/43] qla2xxx: Add counters for Exchange Buffer to debugfs
Date: Tue, 19 Dec 2017 22:56:37 -0800
Message-ID: <20171220065644.21511-37-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0069.outbound.protection.outlook.com ([104.47.40.69]:41840
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932528AbdLTG5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:45 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
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
index 4f0415e158cb..c05ebc6ebe78 100644
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
