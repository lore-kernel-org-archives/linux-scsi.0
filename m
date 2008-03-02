From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/4] scsi_debug: remove unnecessary checking
Date: Sun,  2 Mar 2008 18:30:17 +0900
Message-ID: <1204450218-6858-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1204450218-6858-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204450218-6858-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204450218-6858-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47925 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbYCBJn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:43:58 -0500
In-Reply-To: <1204450218-6858-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c10234f..f70df03 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -344,9 +344,6 @@ int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
 	int inj_transport = 0;
 	int delay_override = 0;
 
-	if (done == NULL)
-		return 0;	/* assume mid level reprocessing command */
-
 	scsi_set_resid(SCpnt, 0);
 	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) && cmd) {
 		printk(KERN_INFO "scsi_debug: cmd ");
-- 
1.5.3.7

