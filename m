From: domen@coderock.org
Subject: [patch 1/1] drivers/scsi/lasi700.c: Use the DMA_32BIT_MASK constant
Date: Sat, 19 Mar 2005 14:19:32 +0100
Message-ID: <20050319131932.9CBD01ECA8@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:44168 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S262545AbVCSNTj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2005 08:19:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, tklauser@nuerscht.ch



Use the DMA_32BIT_MASK constants from dma-mapping.h
when calling dma_set_mask().

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/lasi700.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/lasi700.c~dma_mask-drivers_scsi_lasi700 drivers/scsi/lasi700.c
--- kj/drivers/scsi/lasi700.c~dma_mask-drivers_scsi_lasi700	2005-03-18 20:05:40.000000000 +0100
+++ kj-domen/drivers/scsi/lasi700.c	2005-03-18 20:05:40.000000000 +0100
@@ -111,7 +111,7 @@ lasi700_probe(struct parisc_device *dev)
 	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
 
 	hostdata->dev = &dev->dev;
-	dma_set_mask(&dev->dev, 0xffffffffUL);
+	dma_set_mask(&dev->dev, DMA_32BIT_MASK);
 	hostdata->base = base;
 	hostdata->differential = 0;
 
_
