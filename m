From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 06/29] qla2xxx: Correct print format for edc ql_log() calls.
Date: Thu, 9 Feb 2012 11:15:38 -0800
Message-ID: <1328814961-21866-7-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:31779
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758379Ab2BITcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:10 -0500
Received: from mail60-ch1 (localhost [127.0.0.1])	by mail60-ch1-R.bigfish.com
 (Postfix) with ESMTP id B3C0C3C0557	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:09 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7f895cd..0635be5 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -668,7 +668,7 @@ qla2x00_sysfs_write_edc(struct file *filp, struct kobject *kobj,
 	    dev, adr, len, opt);
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x7074,
-		    "Unable to write EDC (%x) %02x:%04x:%02x:%02x:%02hhx\n",
+		    "Unable to write EDC (%x) %02x:%02x:%04x:%02x:%02hhx\n",
 		    rval, dev, adr, opt, len, buf[8]);
 		return -EIO;
 	}
@@ -725,7 +725,7 @@ qla2x00_sysfs_write_edc_status(struct file *filp, struct kobject *kobj,
 			dev, adr, len, opt);
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_info, vha, 0x7075,
-		    "Unable to write EDC status (%x) %02x:%04x:%02x:%02x.\n",
+		    "Unable to write EDC status (%x) %02x:%02x:%04x:%02x.\n",
 		    rval, dev, adr, opt, len);
 		return -EIO;
 	}
-- 
1.6.0.2


