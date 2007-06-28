From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] CONFIG_SCSI_FD_8xx no longer exists
Date: Thu, 28 Jun 2007 13:53:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706281348590.24833@anakin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:40707 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760685AbXF1LxE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jun 2007 07:53:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, trivial@kernel.org


CONFIG_SCSI_FD_8xx no longer exists.

Apparently it was renamed to CONFIG_SCSI_SEAGATE, but the Makefile was
not correctly updated.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index b1b6327..eb92b31 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -89,7 +89,6 @@ obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
 obj-$(CONFIG_SCSI_SEAGATE)	+= seagate.o
-obj-$(CONFIG_SCSI_FD_8xx)	+= seagate.o
 obj-$(CONFIG_SCSI_T128)		+= t128.o
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
 obj-$(CONFIG_SCSI_DTC3280)	+= dtc.o

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
