From: akpm@linux-foundation.org
Subject: [patch 7/7] aic79xx_core: remove ascii art
Date: Fri, 02 May 2008 13:44:57 -0700
Message-ID: <200805022044.m42Kiv17013977@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936399AbYEBUpB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 16:45:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>

Those '<<<<<<<' lines keep on emitting false-positives when I'm grepping for
git conflicts.  Replace them with '='.

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~aic79xx_core-remove-ascii-art drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~aic79xx_core-remove-ascii-art
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -9745,7 +9745,7 @@ ahd_dump_card_state(struct ahd_softc *ah
 	}
 	saved_modes = ahd_save_modes(ahd);
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
-	printf(">>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<\n"
+	printf("================== Dump Card State Begins =================\n"
 	       "%s: Dumping Card State at program address 0x%x Mode 0x%x\n",
 	       ahd_name(ahd), 
 	       ahd_inw(ahd, CURADDR),
@@ -9981,7 +9981,7 @@ ahd_dump_card_state(struct ahd_softc *ah
 		ahd_outb(ahd, STACK, ahd->saved_stack[i] & 0xFF);
 		ahd_outb(ahd, STACK, (ahd->saved_stack[i] >> 8) & 0xFF);
 	}
-	printf("\n<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n");
+	printf("\n================= Dump Card State Ends ==================\n");
 	ahd_restore_modes(ahd, saved_modes);
 	if (paused == 0)
 		ahd_unpause(ahd);
_
