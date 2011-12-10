From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 16/16] mac_esp: rename irq
Date: Sat, 10 Dec 2011 16:24:57 +1100 (EST)
Message-ID: <alpine.LNX.2.00.1112101606570.13274@nippy.intranet>
References: <20111023141108.856998818@telegraphics.com.au> <20111023141223.838768930@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20111023141223.838768930@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Rename the "Mac ESP" irq as "ESP" to be consistent with all the other 
Mac drivers and ESP drivers.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Re-sending unchanged. Still needs the right ack.


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
