From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 16/18] m68k: Atari SCSI needs NVRAM
Date: Mon, 13 Oct 2008 21:59:02 +0200
Message-ID: <20081013195921.813238693@mail.of.borg>
References: <20081013195846.674654386@mail.of.borg>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from winston.telenet-ops.be ([195.130.137.75]:53445 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYJMUFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Oct 2008 16:05:43 -0400
Content-Disposition: inline; filename=atari-scsi-needs-nvram.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

ERROR: "nvram_read_byte" [drivers/scsi/atari_scsi.ko] undefined!
ERROR: "nvram_check_checksum" [drivers/scsi/atari_scsi.ko] undefined!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1640,6 +1640,7 @@ config ATARI_SCSI
 	tristate "Atari native SCSI support"
 	depends on ATARI && SCSI
 	select SCSI_SPI_ATTRS
+	select NVRAM
 	---help---
 	  If you have an Atari with built-in NCR5380 SCSI controller (TT,
 	  Falcon, ...) say Y to get it supported. Of course also, if you have

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

