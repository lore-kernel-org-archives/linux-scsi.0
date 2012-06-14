From: vikas.chaudhary@qlogic.com
Subject: [PATCH 3/4] qla4xxx: Fix Spell check.
Date: Thu, 14 Jun 2012 10:13:53 -0400
Message-ID: <1339683233-834-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:65529 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755923Ab2FNO3t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2012 10:29:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index bf36723..ddd9472 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -126,7 +126,7 @@ int qla4xxx_init_rings(struct scsi_qla_host *ha)
 
 	qla4xxx_init_response_q_entries(ha);
 
-	/* Initialize mabilbox active array */
+	/* Initialize mailbox active array */
 	for (i = 0; i < MAX_MRB; i++)
 		ha->active_mrb_array[i] = NULL;
 
-- 
1.7.9.1.265.gb3a76

