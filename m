From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH 1/2] bfa: remove unused pci_slot from struct bfa_pcidev_s
Date: Wed, 31 Oct 2012 20:27:46 +0100
Message-ID: <3374605.SkInhuzxbT@eto>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:43051 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759779Ab2JaT1s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Oct 2012 15:27:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krishna C Gudipati <kgudipat@brocade.com>, linux-scsi@vger.kernel.org

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/scsi/bfa/bfa_ioc.h | 1 -
 drivers/scsi/bfa/bfad.c    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index b2856f9..80a2c15 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -150,7 +150,6 @@ struct bfa_meminfo_s {
  * PCI device information required by IOC
  */
 struct bfa_pcidev_s {
-	int		pci_slot;
 	u8		pci_func;
 	u16		device_id;
 	u16		ssid;
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index c374949..2543fc3 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -750,7 +750,6 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 		goto out_release_region;
 	}
 
-	bfad->hal_pcidev.pci_slot = PCI_SLOT(pdev->devfn);
 	bfad->hal_pcidev.pci_func = PCI_FUNC(pdev->devfn);
 	bfad->hal_pcidev.pci_bar_kva = bfad->pci_bar0_kva;
 	bfad->hal_pcidev.device_id = pdev->device;
-- 
1.7.7

