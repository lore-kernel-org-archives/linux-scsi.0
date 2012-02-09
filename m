From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 17/29] qla2xxx: Fix ql_dbg arguments.
Date: Thu, 9 Feb 2012 11:15:49 -0800
Message-ID: <1328814961-21866-18-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:3906
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758402Ab2BITcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:12 -0500
Received: from mail39-ch1 (localhost [127.0.0.1])	by mail39-ch1-R.bigfish.com
 (Postfix) with ESMTP id 8441D80591	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:11 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index b251b4d..751846f 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -4142,7 +4142,7 @@ qla82xx_md_collect(scsi_qla_host_t *vha)
 
 	total_data_size = ha->md_dump_size;
 
-	ql_dbg(ql_log_info, vha, 0xb03d,
+	ql_dbg(ql_dbg_p3p, vha, 0xb03d,
 	    "Total minidump data_size 0x%x to be captured\n", total_data_size);
 
 	/* Check whether template obtained is valid */
@@ -4265,7 +4265,7 @@ skip_nxt_entry:
 	}
 
 	if (data_collected != total_data_size) {
-		ql_dbg(ql_log_warn, vha, 0xb043,
+		ql_dbg(ql_dbg_p3p, vha, 0xb043,
 		    "MiniDump data mismatch: Data collected: [0x%x],"
 		    "total_data_size:[0x%x]\n",
 		    data_collected, total_data_size);
-- 
1.6.0.2


