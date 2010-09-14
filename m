From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH 12/17]: SCST dev handlers' Makefile
Date: Tue, 14 Sep 2010 18:46:47 +0400
Message-ID: <4C8F8AD7.9080809@vlnb.net>
References: <4C8F886E.2080407@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab0INOsX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2010 10:48:23 -0400
In-Reply-To: <4C8F886E.2080407@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>

This patch contains SCST dev handlers' Makefile.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 Makefile |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -uprN orig/linux-2.6.35/drivers/scst/dev_handlers/Makefile linux-2.6.35/drivers/scst/dev_handlers/Makefile
--- orig/linux-2.6.35/drivers/scst/dev_handlers/Makefile
+++ linux-2.6.35/drivers/scst/dev_handlers/Makefile
@@ -0,0 +1,13 @@
+ccflags-y += -Wno-unused-parameter
+
+obj-m := scst_cdrom.o scst_changer.o scst_disk.o scst_modisk.o scst_tape.o \
+	scst_vdisk.o scst_raid.o scst_processor.o
+
+obj-$(CONFIG_SCST_DISK)		+= scst_disk.o
+obj-$(CONFIG_SCST_TAPE)		+= scst_tape.o
+obj-$(CONFIG_SCST_CDROM)	+= scst_cdrom.o
+obj-$(CONFIG_SCST_MODISK)	+= scst_modisk.o
+obj-$(CONFIG_SCST_CHANGER)	+= scst_changer.o
+obj-$(CONFIG_SCST_RAID)		+= scst_raid.o
+obj-$(CONFIG_SCST_PROCESSOR)	+= scst_processor.o
+obj-$(CONFIG_SCST_VDISK)	+= scst_vdisk.o

