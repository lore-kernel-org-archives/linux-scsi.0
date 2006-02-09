From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [Fwd: [SCSI] jazz_esp: Fix sparse warnings.]
Date: Thu, 09 Feb 2006 11:16:27 -0500
Message-ID: <1139501787.3275.23.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:52628 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932580AbWBIQQ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 11:16:29 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k19GGS222326
	for <linux-scsi@vger.kernel.org>; Thu, 9 Feb 2006 11:16:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

-------- Forwarded Message --------
From: Ralf Baechle <ralf@linux-mips.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [SCSI] jazz_esp: Fix sparse warnings.
Date: Wed, 8 Feb 2006 22:40:57 +0000

"Using plain integer as NULL pointer".
    
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

---
 drivers/scsi/jazz_esp.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

Index: upstream-linus.git/drivers/scsi/jazz_esp.c
===================================================================
--- upstream-linus.git.orig/drivers/scsi/jazz_esp.c
+++ upstream-linus.git/drivers/scsi/jazz_esp.c
@@ -75,7 +75,7 @@ static int jazz_esp_detect(struct scsi_h
      * first assumption it is there:-)
      */
     if (1) {
-	esp_dev = 0;
+	esp_dev = NULL;
 	esp = esp_allocate(tpnt, (void *) esp_dev);
 	
 	/* Do command transfer with programmed I/O */
@@ -94,13 +94,13 @@ static int jazz_esp_detect(struct scsi_h
 	esp->dma_setup = &dma_setup;
 
 	/* Optional functions */
-	esp->dma_barrier = 0;
-	esp->dma_drain = 0;
-	esp->dma_invalidate = 0;
-	esp->dma_irq_entry = 0;
-	esp->dma_irq_exit = 0;
-	esp->dma_poll = 0;
-	esp->dma_reset = 0;
+	esp->dma_barrier = NULL;
+	esp->dma_drain = NULL;
+	esp->dma_invalidate = NULL;
+	esp->dma_irq_entry = NULL;
+	esp->dma_irq_exit = NULL;
+	esp->dma_poll = NULL;
+	esp->dma_reset = NULL;
 	esp->dma_led_off = &dma_led_off;
 	esp->dma_led_on = &dma_led_on;
 	
@@ -120,7 +120,7 @@ static int jazz_esp_detect(struct scsi_h
 	 * of DMA channel, so we can use the jazz DMA functions
 	 * 
 	 */
-	esp->dregs = JAZZ_SCSI_DMA;
+	esp->dregs = (void *) JAZZ_SCSI_DMA;
 	
 	/* ESP register base */
 	esp->eregs = (struct ESP_regs *)(JAZZ_SCSI_BASE);

