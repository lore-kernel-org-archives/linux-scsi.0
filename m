From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/TRIVIAL 3/4] [SCSI] aic7xxx: Grammar s/if ... if/if ... is/
Date: Thu, 27 Nov 2014 12:05:45 +0100
Message-ID: <1417086346-23698-3-git-send-email-geert+renesas@glider.be>
References: <1417086346-23698-1-git-send-email-geert+renesas@glider.be>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:35043 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaK0LFw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Nov 2014 06:05:52 -0500
In-Reply-To: <1417086346-23698-1-git-send-email-geert+renesas@glider.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 0bcacf71aef814fe..97f2accd3dbb48ac 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1298,7 +1298,7 @@ rescan_fifos:
 
 	/*
 	 * Wait for any inprogress DMA to complete and clear DMA state
-	 * if this if for an SCB in the qinfifo.
+	 * if this is for an SCB in the qinfifo.
 	 */
 	while (((ccscbctl = ahd_inb(ahd, CCSCBCTL)) & (CCARREN|CCSCBEN)) != 0) {
 
-- 
1.9.1

