From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] CONFIG_SCSI_MAC_ESP needs CONFIG_SCSI_SPI_ATTRS
Date: Mon, 5 May 2008 21:27:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805052126200.28495@anakin>
References: <Pine.LNX.4.64.0805052118050.24098@anakin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761047AbYEET1k@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0805052118050.24098@anakin>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux/m68k <linux-m68k@vger.kernel.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

The new mac_esp scsi driver needs CONFIG_SCSI_SPI_ATTRS, just like all other
drivers using the new esp_scsi core.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1679,6 +1679,7 @@ config MAC_SCSI
 config SCSI_MAC_ESP
 	tristate "Macintosh NCR53c9[46] SCSI"
 	depends on MAC && SCSI
+	select SCSI_SPI_ATTRS
 	help
 	  This is the NCR 53c9x SCSI controller found on most of the 68040
 	  based Macintoshes.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
