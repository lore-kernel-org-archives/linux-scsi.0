From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: PATCH: atp870u DMA mask
Date: Fri, 11 Mar 2005 14:17:55 +0000
Message-ID: <1110550674.15927.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from clock-tower.bc.nu ([81.2.110.250]:408 "EHLO lxorguk.ukuu.org.uk")
	by vger.kernel.org with ESMTP id S263330AbVCKOTk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 09:19:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org, linux-scsi@vger.kernel.org

Noted by James Bottomley

Signed-off-by: Alan Cox <alan@redhat.com>

--- drivers/scsi/atp870u.c.old	2005-03-11 14:14:53.015465656 +0000
+++ drivers/scsi/atp870u.c	2005-03-11 14:15:24.950610776 +0000
@@ -2634,7 +2634,7 @@
 	if (pci_enable_device(pdev))
 		return -EIO;
 
-        if (!pci_set_dma_mask(pdev, 0xFFFFFFUL)) {
+        if (!pci_set_dma_mask(pdev, 0xFFFFFFFFUL)) {
                 printk(KERN_INFO "atp870u: use 32bit DMA mask.\n");
         } else {
                 printk(KERN_ERR "atp870u: DMA mask required but not available.\n");

