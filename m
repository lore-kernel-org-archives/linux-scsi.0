From: domen@coderock.org
Subject: [patch 5/7] scsi/zalon: Added KERN macro to printk()
Date: Wed, 12 Jan 2005 00:23:00 +0100
Message-ID: <20050111232300.DED921F225@trashy.coderock.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:32709 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S262938AbVAKXXJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 18:23:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, am@misk.net



Hi,

I have added a KERN macro to a printk() function as requested in the Kernel
Janitor's TODO list.

Signed-off-by: Andrew McGregor <am@misk.net>

--

Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/zalon.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/zalon.c~printk-drivers-scsi-zalon drivers/scsi/zalon.c
--- kj/drivers/scsi/zalon.c~printk-drivers-scsi-zalon	2005-01-10 18:00:29.000000000 +0100
+++ kj-domen/drivers/scsi/zalon.c	2005-01-10 18:00:29.000000000 +0100
@@ -109,7 +109,7 @@ zalon_probe(struct parisc_device *dev)
 	*/
 	irq = gsc_alloc_irq(&gsc_irq);
 
-	printk("%s: Zalon vers field is 0x%x, IRQ %d\n", __FUNCTION__,
+       printk(KERN_INFO "%s: Zalon vers field is 0x%x, IRQ %d\n", __FUNCTION__,
 		zalon_vers, irq);
 
 	__raw_writel(gsc_irq.txn_addr | gsc_irq.txn_data, dev->hpa + IO_MODULE_EIM);
_
