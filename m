From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 09/10] m68k: Fix a few hickups in drivers/scsi/Kconfig
Date: Wed, 15 Aug 2007 11:45:48 +0200
Message-ID: <20070815094850.869999871@mail.of.borg>
References: <20070815094539.181979221@mail.of.borg>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:58730 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181AbXHOJt7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 05:49:59 -0400
Content-Disposition: inline; filename=m68k-scsi-Kconfig-hickups.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

m68k: Fix a few hickups in drivers/scsi/Kconfig

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1561,7 +1561,7 @@ config A3000_SCSI
 	  built-in SCSI controller, say Y. Otherwise, say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called wd33c93.
+	  module will be called a3000.
 
 config A2091_SCSI
 	tristate "A2091/A590 WD33C93A support"
@@ -1571,7 +1571,7 @@ config A2091_SCSI
 	  say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called wd33c93.
+	  module will be called a2091.
 
 config GVP11_SCSI
 	tristate "GVP Series II WD33C93A support"

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

