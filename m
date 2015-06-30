From: Nik Nyby <nikolas@gnu.org>
Subject: [PATCH] scsi/arcmsr: Fix typos in error log
Date: Tue, 30 Jun 2015 17:25:27 -0400
Message-ID: <1435699527-14760-1-git-send-email-nikolas@gnu.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:43724 "EHLO eggs.gnu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbbF3VZo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2015 17:25:44 -0400
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
	(envelope-from <nikolas@gnu.org>)
	id 1ZA32F-0002hc-G5
	for linux-scsi@vger.kernel.org; Tue, 30 Jun 2015 17:25:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, trivial@kernel.org
Cc: Nik Nyby <nikolas@gnu.org>

This fixes some typos in one of the error logs.

Signed-off-by: Nik Nyby <nikolas@gnu.org>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 914c39f..6ac74fb 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -3264,7 +3264,7 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 		reg->doneq_index = 0;
 		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);
 		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \
+			printk(KERN_NOTICE "arcmsr%d: cannot set driver mode\n", \
 				acb->host->host_no);
 			return 1;
 		}
-- 
2.1.4

