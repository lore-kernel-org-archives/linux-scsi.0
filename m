From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] depends on PCI DMA API: Adaptec AIC7xxx_old
Date: Tue, 20 Jul 2004 20:39:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200407201839.i6KIdo2I015550@anakin.of.borg>
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S266139AbUGTTXI@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Adaptec AIC7xxx_old unconditionally depends on the PCI DMA API, so mark it
broken if !PCI

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

--- linux-2.6.8-rc2/drivers/scsi/Kconfig	2004-07-18 15:55:26.000000000 +0200
+++ linux-m68k-2.6.8-rc2/drivers/scsi/Kconfig	2004-07-19 23:16:48.000000000 +0200
@@ -320,7 +320,7 @@
 
 config SCSI_AIC7XXX_OLD
 	tristate "Adaptec AIC7xxx support (old driver)"
-	depends on SCSI
+	depends on SCSI && (PCI || BROKEN)
 	help
 	  WARNING This driver is an older aic7xxx driver and is no longer
 	  under active development.  Adaptec, Inc. is writing a new driver to

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
