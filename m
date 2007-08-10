From: akpm@linux-foundation.org
Subject: [patch 23/30] drivers/scsi/lpfc/lpfc_scsi.c: kmalloc + memset conversion to kzalloc
Date: Fri, 10 Aug 2007 14:50:48 -0700
Message-ID: <200708102150.l7ALomF6011387@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756891AbXHJWBW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, m.kozlowski@tuxland.pl, James.Smart@Emulex.Com

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_scsi.c | 42769 -> 42721 (-48 bytes)
 drivers/scsi/lpfc/lpfc_scsi.o | 191332 -> 191240 (-92 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: James Smart <James.Smart@Emulex.Com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_scsi.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_scsi.c~drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c~drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/scsi/lpfc/lpfc_scsi.c
@@ -202,10 +202,9 @@ lpfc_new_scsi_buf(struct lpfc_vport *vpo
 	dma_addr_t pdma_phys;
 	uint16_t iotag;
 
-	psb = kmalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
+	psb = kzalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
 	if (!psb)
 		return NULL;
-	memset(psb, 0, sizeof (struct lpfc_scsi_buf));
 
 	/*
 	 * Get memory from the pci pool to map the virt space to pci bus space
_
