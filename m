From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [PATCH 16/19] drivers/scsi/nsp32: Use the DMA_{64,32}BIT_MASK constants
Date: Sun, 20 Feb 2005 18:11:11 +0100
Message-ID: <20050220171111.GQ14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:1294 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261890AbVBTRKZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 12:10:25 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@lists.osdl.org
Cc: linux-scsi@vger.kernel.org

Hello,

Description: Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h
when calling pci_set_dma_mask() or pci_set_consistent_dma_mask()
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

--- linux-2.6.11-rc4.orig/drivers/scsi/nsp32.c	2005-02-13 17:13:07.000000000 +0100
+++ linux-2.6.11-rc4/drivers/scsi/nsp32.c	2005-02-16 21:30:52.000000000 +0100
@@ -2779,7 +2779,7 @@ static int nsp32_detect(Scsi_Host_Templa
 	/*
 	 * setup DMA 
 	 */
-	if (pci_set_dma_mask(PCIDEV, 0xffffffffUL) != 0) {
+	if (pci_set_dma_mask(PCIDEV, DMA_32BIT_MASK) != 0) {
 		nsp32_msg (KERN_ERR, "failed to set PCI DMA mask");
 		goto scsi_unregister;
 	}
