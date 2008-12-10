From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 11/23]: Makefile for SCST backend handlers
Date: Wed, 10 Dec 2008 21:46:01 +0300
Message-ID: <49400E69.2020509@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:64097 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbYLJSp7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:45:59 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains Makefile for SCST backend handlers.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/dev_handlers/Makefile |   14 ++++++++++++++
  1 file changed, 14 insertions(+)

diff -uprN orig/linux-2.6.27/drivers/scst/dev_handlers/Makefile linux-2.6.27/drivers/scst/dev_handlers/Makefile
--- orig/linux-2.6.27/drivers/scst/dev_handlers/Makefile
+++ linux-2.6.27/drivers/scst/dev_handlers/Makefile
@@ -0,0 +1,14 @@
+EXTRA_CFLAGS += -Iinclude/scst -Wno-unused-parameter
+
+obj-m := scst_cdrom.o scst_changer.o scst_disk.o scst_modisk.o scst_tape.o \
+	scst_vdisk.o scst_raid.o scst_processor.o scst_user.o
+
+obj-$(CONFIG_SCST_DISK)		+= scst_disk.o
+obj-$(CONFIG_SCST_TAPE)		+= scst_tape.o
+obj-$(CONFIG_SCST_CDROM)	+= scst_cdrom.o
+obj-$(CONFIG_SCST_MODISK)	+= scst_modisk.o
+obj-$(CONFIG_SCST_CHANGER)	+= scst_changer.o
+obj-$(CONFIG_SCST_RAID)		+= scst_raid.o
+obj-$(CONFIG_SCST_PROCESSOR)	+= scst_processor.o
+obj-$(CONFIG_SCST_VDISK)	+= scst_vdisk.o
+obj-$(CONFIG_SCST_USER)		+= scst_user.o


