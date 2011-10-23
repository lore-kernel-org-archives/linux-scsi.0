From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 16/16] mac_esp: rename irq
Date: Mon, 24 Oct 2011 01:11:24 +1100
Message-ID: <20111023141223.838768930@telegraphics.com.au>
References: <20111023141108.856998818@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=mac-esp-irq-name
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Rename the "Mac ESP" irq as "ESP" to be consistent with all the other Mac drivers and ESP drivers.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Index: linux-m68k/drivers/scsi/mac_esp.c
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_esp.c	2011-10-23 18:18:46.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_esp.c	2011-10-23 18:19:30.000000000 +1100
@@ -565,8 +565,7 @@ static int __devinit esp_mac_probe(struc
 	esp_chips[dev->id] = esp;
 	mb();
 	if (esp_chips[!dev->id] == NULL) {
-		err = request_irq(host->irq, mac_scsi_esp_intr, 0,
-		                  "Mac ESP", NULL);
+		err = request_irq(host->irq, mac_scsi_esp_intr, 0, "ESP", NULL);
 		if (err < 0) {
 			esp_chips[dev->id] = NULL;
 			goto fail_free_priv;
