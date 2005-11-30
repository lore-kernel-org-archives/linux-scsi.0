From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 5/11] [SYM2] Use DMA_40BIT_MASK constant
Date: Tue, 29 Nov 2005 23:08:36 -0500 (EST)
Message-ID: <20051130040836.340E67626C@gonzo>
References: <20051130040537.GC1597@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:53205 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1750853AbVK3EIi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 23:08:38 -0500
Received: from mail2.magma.ca (mail2.magma.ca [206.191.0.214])
	by mx1.magmacom.com (8.13.0/8.13.0) with ESMTP id jAU48bwl002575
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:38 -0500
Received: from gonzo (ottawa-hs-209-217-123-220.d-ip.magma.ca [209.217.123.220])
	by mail2.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48aOs002578
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:37 -0500
In-Reply-To: <20051130040537.GC1597@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Now that this constant has been added to dma-mapping.h, we don't need our
own definition

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_glue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

applies-to: 373e17c364b620aacf967bc5a672dc2f544edf45
4ffa94c6b6bf4b80857e22fb0a2813e4b3298402
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index b39151f..46a132e 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1532,7 +1532,7 @@ static int sym_setup_bus_dma_mask(struct
 {
 #if SYM_CONF_DMA_ADDRESSING_MODE > 0
 #if   SYM_CONF_DMA_ADDRESSING_MODE == 1
-#define	DMA_DAC_MASK	0x000000ffffffffffULL /* 40-bit */
+#define	DMA_DAC_MASK	DMA_40BIT_MASK
 #elif SYM_CONF_DMA_ADDRESSING_MODE == 2
 #define	DMA_DAC_MASK	DMA_64BIT_MASK
 #endif
---
0.99.9.GIT
