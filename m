From: akpm@linux-foundation.org
Subject: [patch 24/25] scsi: remove __GFP_DMA
Date: Wed, 23 May 2007 14:41:55 -0700
Message-ID: <200705232141.l4NLftHl001242@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756890AbXEWWEE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 18:04:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bwalle@suse.de, James.Bottomley@steeleye.com, clameter@sgi.com

From: Bernhard Walle <bwalle@suse.de>

After 821de3a27bf33f11ec878562577c586cd5f83c64, it's not necessary to
allocate a DMA buffer any more in sd.c.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sd.c~scsi-remove-__gfp_dma drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-remove-__gfp_dma
+++ a/drivers/scsi/sd.c
@@ -1515,7 +1515,7 @@ static int sd_revalidate_disk(struct gen
 	if (!scsi_device_online(sdp))
 		goto out;
 
-	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL | __GFP_DMA);
+	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
 	if (!buffer) {
 		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
 			  "allocation failure.\n");
_
