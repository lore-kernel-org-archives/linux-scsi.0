From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 16/29] qla2xxx: Use ql_log* #define's in ql_log() and ql_log_pci().
Date: Thu, 9 Feb 2012 11:15:48 -0800
Message-ID: <1328814961-21866-17-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:3789
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758450Ab2BITcO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:14 -0500
Received: from mail52-ch1 (localhost [127.0.0.1])	by mail52-ch1-R.bigfish.com
 (Postfix) with ESMTP id D84A53E0635	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:11 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 472ee5e..e915310 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2364,13 +2364,13 @@ ql_log(uint32_t level, scsi_qla_host_t *vha, int32_t id, const char *fmt, ...)
 	vaf.va = &va;
 
 	switch (level) {
-	case 0: /* FATAL LOG */
+	case ql_log_fatal: /* FATAL LOG */
 		pr_crit("%s%pV", pbuf, &vaf);
 		break;
-	case 1:
+	case ql_log_warn:
 		pr_err("%s%pV", pbuf, &vaf);
 		break;
-	case 2:
+	case ql_log_info:
 		pr_warn("%s%pV", pbuf, &vaf);
 		break;
 	default:
@@ -2419,13 +2419,13 @@ ql_log_pci(uint32_t level, struct pci_dev *pdev, int32_t id,
 	vaf.va = &va;
 
 	switch (level) {
-	case 0: /* FATAL LOG */
+	case ql_log_fatal: /* FATAL LOG */
 		pr_crit("%s%pV", pbuf, &vaf);
 		break;
-	case 1:
+	case ql_log_warn:
 		pr_err("%s%pV", pbuf, &vaf);
 		break;
-	case 2:
+	case ql_log_info:
 		pr_warn("%s%pV", pbuf, &vaf);
 		break;
 	default:
-- 
1.6.0.2


