From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [PATCH 08/19] drivers/scsi/BusLogic: Use the DMA_{64,32}BIT_MASK constants
Date: Sun, 20 Feb 2005 18:02:39 +0100
Message-ID: <20050220170239.GI14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:52745 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261881AbVBTRBy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 12:01:54 -0500
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

--- linux-2.6.11-rc4.orig/drivers/scsi/BusLogic.c	2005-02-13 17:13:07.000000000 +0100
+++ linux-2.6.11-rc4/drivers/scsi/BusLogic.c	2005-02-16 21:13:15.000000000 +0100
@@ -676,7 +676,7 @@ static int __init BusLogic_InitializeMul
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
@@ -831,7 +831,7 @@ static int __init BusLogic_InitializeMul
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
@@ -885,7 +885,7 @@ static int __init BusLogic_InitializeFla
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
