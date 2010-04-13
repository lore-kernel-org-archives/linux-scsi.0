From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH][RFC 1/3/2/5] SCST dev handlers' Makefile
Date: Tue, 13 Apr 2010 17:07:45 +0400
Message-ID: <4BC46CA1.1080306@vlnb.net>
References: <4BC45A32.2010904@vlnb.net> <4BC46173.7000102@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:60658 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab0DMNIE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2010 09:08:04 -0400
In-Reply-To: <4BC46173.7000102@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>

This patch contains SCST dev handlers' Makefile.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 Makefile |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -uprN orig/linux-2.6.33/drivers/scst/dev_handlers/Makefile linux-2.6.33/drivers/scst/dev_handlers/Makefile
--- orig/linux-2.6.33/drivers/scst/dev_handlers/Makefile
+++ linux-2.6.33/drivers/scst/dev_handlers/Makefile
@@ -0,0 +1,13 @@
+ccflags-y += -Iinclude/scst -Wno-unused-parameter
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

