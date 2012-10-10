From: vikas.chaudhary@qlogic.com
Subject: [PATCH 1/7] qla4xxx: Allow reset in link down case
Date: Wed, 10 Oct 2012 07:24:40 -0400
Message-ID: <1349868286-13650-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:38200 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752755Ab2JJLnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 07:43:09 -0400
In-Reply-To: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ad2da9c..fbfa948 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6008,14 +6008,6 @@ static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type)
 		goto exit_host_reset;
 	}
 
-	rval = qla4xxx_wait_for_hba_online(ha);
-	if (rval != QLA_SUCCESS) {
-		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Unable to reset host "
-				  "adapter\n", __func__));
-		rval = -EIO;
-		goto exit_host_reset;
-	}
-
 	if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
 		goto recover_adapter;
 
-- 
1.7.8.GIT

