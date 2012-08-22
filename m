From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 29/42] qla2xxx: Fix description of qla2xmaxqdepth parameter.
Date: Wed, 22 Aug 2012 14:21:23 -0400
Message-ID: <1345659696-3670-30-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:33418 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S965004Ab2HVSib (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:31 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2c95468..deef57a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -113,7 +113,8 @@ MODULE_PARM_DESC(ql2xfdmienable,
 static int ql2xmaxqdepth = MAX_Q_DEPTH;
 module_param(ql2xmaxqdepth, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xmaxqdepth,
-		"Maximum queue depth to report for target devices.");
+		"Maximum queue depth to set for each LUN. "
+		"Default is 32.");
 
 /* Do not change the value of this after module load */
 int ql2xenabledif = 0;
-- 
1.7.7

