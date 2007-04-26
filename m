From: akpm@linux-foundation.org
Subject: [patch 28/30] qla1280: use DMA_64BIT_MASK instead of ~0ULL
Date: Thu, 26 Apr 2007 00:35:31 -0700
Message-ID: <200704260735.l3Q7ZVsa024295@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933510AbXDZH6J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 03:58:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, matthias.kaehlcke@gmail.com

From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

QLA1280: call pci_set_dma_mask with DMA_64BIT_MASK instead of  ~0ULL

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla1280.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/qla1280.c~qla1280-use-dma_64bit_mask-instead-of-0ull drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c~qla1280-use-dma_64bit_mask-instead-of-0ull
+++ a/drivers/scsi/qla1280.c
@@ -4293,7 +4293,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 	ha->devnum = devnum;	/* specifies microcode load address */
 
 #ifdef QLA_64BIT_PTR
-	if (pci_set_dma_mask(ha->pdev, (dma_addr_t) ~ 0ULL)) {
+	if (pci_set_dma_mask(ha->pdev, DMA_64BIT_MASK)) {
 		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
_
