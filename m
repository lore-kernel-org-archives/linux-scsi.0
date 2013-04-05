From: vikas.chaudhary@qlogic.com
Subject: [PATCH 3/5] qla4xxx: Use correct value for max flash node entries
Date: Fri,  5 Apr 2013 07:06:08 -0400
Message-ID: <1365159970-17672-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:41394 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751763Ab3DEL3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Apr 2013 07:29:40 -0400
In-Reply-To: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Use correct value for max flash node entries supported
based on adapter type.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f82efcb..a47f999 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5587,7 +5587,7 @@ static int qla4xxx_sysfs_ddb_add(struct Scsi_Host *shost, const char *buf,
 		goto exit_ddb_add;
 	}
 
-	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
+	max_ddbs =  is_qla40XX(ha) ? MAX_PRST_DEV_DB_ENTRIES :
 				     MAX_DEV_DB_ENTRIES;
 
 	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
@@ -6707,7 +6707,7 @@ static int qla4xxx_sysfs_ddb_export(struct scsi_qla_host *ha)
 		return -ENOMEM;
 	}
 
-	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
+	max_ddbs =  is_qla40XX(ha) ? MAX_PRST_DEV_DB_ENTRIES :
 				     MAX_DEV_DB_ENTRIES;
 
 	for (idx = 0; idx < max_ddbs; idx++) {
-- 
1.8.2.GIT

