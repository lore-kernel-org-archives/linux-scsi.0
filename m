From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] am53c974: remove left-over debugging code
Date: Mon,  2 Feb 2015 08:33:16 +0100
Message-ID: <1422862396-70220-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245AbbBBHdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2015 02:33:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Ondrej Zary <linux@rainbow-software.org>

A shost_printk() statement was left over from debugging.
It can safely be removed; the same information is displayed
in the debugging message some lines further down.

Cc: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/am53c974.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index aa3e2c7..a6f5ee8 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -178,12 +178,6 @@ static void pci_esp_dma_drain(struct esp *esp)
 			break;
 		cpu_relax();
 	}
-	if (resid > 1) {
-		/* FIFO not cleared */
-		shost_printk(KERN_INFO, esp->host,
-			     "FIFO not cleared, %d bytes left\n",
-			     resid);
-	}
 
 	/*
 	 * When there is a residual BCMPLT will never be set
-- 
1.8.5.2

