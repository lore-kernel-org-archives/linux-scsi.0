From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 1/7] qla4xxx: Correct the check for local CHAP entry type
Date: Tue, 17 Sep 2013 07:54:44 -0400
Message-ID: <1379418890-1141-2-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:35887 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752528Ab3IQMZT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 08:25:19 -0400
In-Reply-To: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Use correct bit flag to check the type of CHAP entry.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 62d4208..5eef7d1 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1611,7 +1611,7 @@ int qla4xxx_get_uni_chap_at_index(struct scsi_qla_host *ha, char *username,
 		goto exit_unlock_uni_chap;
 	}
 
-	if (!(chap_table->flags & BIT_6)) {
+	if (!(chap_table->flags & BIT_7)) {
 		ql4_printk(KERN_ERR, ha, "Unidirectional entry not set\n");
 		rval = QLA_ERROR;
 		goto exit_unlock_uni_chap;
-- 
1.7.1

