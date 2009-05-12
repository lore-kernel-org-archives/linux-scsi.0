From: akpm@linux-foundation.org
Subject: [patch for 2.6.30? 1/1] drivers/scsi/NCR_D700.c: fix IRQ handler return type
Date: Tue, 12 May 2009 13:29:13 -0700
Message-ID: <200905122048.n4CKmSw7030088@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbZELUvG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2009 16:51:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, helight.xu@gmail.com, James.Bottomley@HansenPartnership.com

From: Zhenwen Xu <helight.xu@gmail.com>

drivers/scsi/NCR_D700.c: In function `NCR_D700_probe':
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of `request_irq' from incompatible pointer type
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of `request_irq' from incompatible pointer type
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of `request_irq' from incompatible pointer type

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/NCR_D700.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/NCR_D700.c~drivers-scsi-ncr_d700c-fix-irq-handler-return-type drivers/scsi/NCR_D700.c
--- a/drivers/scsi/NCR_D700.c~drivers-scsi-ncr_d700c-fix-irq-handler-return-type
+++ a/drivers/scsi/NCR_D700.c
@@ -224,7 +224,7 @@ NCR_D700_probe_one(struct NCR_D700_priva
 	return ret;
 }
 
-static int
+static irqreturn_t
 NCR_D700_intr(int irq, void *data)
 {
 	struct NCR_D700_private *p = (struct NCR_D700_private *)data;
_
