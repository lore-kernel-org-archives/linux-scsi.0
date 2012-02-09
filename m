From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 20/29] qla2xxx: Change the log message when previous dump is available to retrieve for ISP82xx.
Date: Thu, 9 Feb 2012 11:15:52 -0800
Message-ID: <1328814961-21866-21-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:23076
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758422Ab2BITcN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:13 -0500
Received: from mail116-ch1 (localhost [127.0.0.1])	by
 mail116-ch1-R.bigfish.com (Postfix) with ESMTP id D09FA3605F4	for
 <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2012 19:32:12 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 751846f..f052853 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -4098,8 +4098,9 @@ qla82xx_md_collect(scsi_qla_host_t *vha)
 	data_ptr = (uint32_t *)ha->md_dump;
 
 	if (ha->fw_dumped) {
-		ql_log(ql_log_info, vha, 0xb037,
-		    "Firmware dump available to retrive\n");
+		ql_log(ql_log_warn, vha, 0xb037,
+		    "Firmware has been previously dumped (%p) "
+		    "-- ignoring request.\n", ha->fw_dump);
 		goto md_failed;
 	}
 
-- 
1.6.0.2


