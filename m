From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 12/15] qla2xxx: Fix warnings about inconsistent indenting
Date: Thu, 2 Feb 2017 11:42:35 -0800
Message-ID: <1486064558-365-13-git-send-email-himanshu.madhani@cavium.com>
References: <1486064558-365-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0083.outbound.protection.outlook.com ([104.47.41.83]:37376
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751681AbdBBUAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Feb 2017 15:00:00 -0500
In-Reply-To: <1486064558-365-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Fix following warning reported by smatch tool.

drivers/scsi/qla2xxx/qla_mbx.c:128 qla2x00_mailbox_command() warn: inconsistent
indenting

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index dcd190a..e07c960 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -124,12 +124,11 @@ static int is_rom_cmd(uint16_t cmd)
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
-	 /* if PCI error, then avoid mbx processing.*/
-	 if (test_bit(PCI_ERR, &base_vha->dpc_flags)) {
-		ql_log(ql_log_warn, vha, 0x1191,
-		    "PCI error, exiting.\n");
+	/* if PCI error, then avoid mbx processing.*/
+	if (test_bit(PCI_ERR, &base_vha->dpc_flags)) {
+		ql_log(ql_log_warn, vha, 0x1191, "PCI error, exiting.\n");
 		return QLA_FUNCTION_TIMEOUT;
-	 }
+	}
 
 	reg = ha->iobase;
 	io_lock_on = base_vha->flags.init_done;
-- 
1.8.3.1
