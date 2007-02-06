From: akpm@linux-foundation.org
Subject: [patch 20/33] scsi: 53c7xx brackets fix
Date: Mon, 05 Feb 2007 16:38:53 -0800
Message-ID: <200702060039.l160duDf005011@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965341AbXBFAkB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Feb 2007 19:40:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, m.kozlowski@tuxland.pl

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/53c7xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/53c7xx.c~scsi-53c7xx-brackets-fix drivers/scsi/53c7xx.c
--- a/drivers/scsi/53c7xx.c~scsi-53c7xx-brackets-fix
+++ a/drivers/scsi/53c7xx.c
@@ -4400,7 +4400,7 @@ abort_connected (struct Scsi_Host *host)
  * account the current synchronous offset) 
  */
 
-    sstat = (NCR53c8x0_read8 (SSTAT2_REG);
+    sstat = NCR53c8x0_read8 (SSTAT2_REG);
     offset = OFFSET (sstat & SSTAT2_FF_MASK) >> SSTAT2_FF_SHIFT;
     phase = sstat & SSTAT2_PHASE_MASK;
 
@@ -5423,7 +5423,7 @@ insn_to_offset (Scsi_Cmnd *cmd, u32 *ins
     	    	     --buffers, offset += segment->length, ++segment)
 #if 0
 		    printk("scsi%d: comparing 0x%p to 0x%p\n", 
-			cmd->device->host->host_no, saved, page_address(segment->page+segment->offset);
+			cmd->device->host->host_no, saved, page_address(segment->page+segment->offset));
 #else
 		    ;
 #endif
_
