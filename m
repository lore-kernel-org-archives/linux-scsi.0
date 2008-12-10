From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 7/23]: SCST integration into the kernel
Date: Wed, 10 Dec 2008 21:40:50 +0300
Message-ID: <49400D32.5000406@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:63633 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYLJSkj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:40:39 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains the changes necessary to integrate SCST into the
kernel build system by adding the SCST target framework as an entry
under drivers.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/Kconfig  |    2 ++
  drivers/Makefile |    1 +
  2 files changed, 3 insertions(+)

diff -upkr -X linux-2.6.26/Documentation/dontdiff linux-2.6.26/drivers/Kconfig linux-2.6.26/drivers/Kconfig
--- orig/linux-2.6.27/drivers/Kconfig 01:51:29.000000000 +0400
+++ linux-2.6.27/drivers/Kconfig 14:14:46.000000000 +0400
@@ -24,6 +24,8 @@ source "drivers/ide/Kconfig"
 
 source "drivers/scsi/Kconfig"
 
+source "drivers/scst/Kconfig"
+
 source "drivers/ata/Kconfig"
 
 source "drivers/md/Kconfig"
diff -upkr -X linux-2.6.26/Documentation/dontdiff linux-2.6.26/drivers/Makefile linux-2.6.26/drivers/Makefile
--- orig/linux-2.6.27/drivers/Makefile 01:51:29.000000000 +0400
+++ linux-2.6.27/drivers/Makefile 14:15:29.000000000 +0400
@@ -39,6 +39,7 @@ obj-$(CONFIG_ATM)		+= atm/
 obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
 obj-$(CONFIG_SCSI)		+= scsi/
+obj-$(CONFIG_SCST)		+= scst/
 obj-$(CONFIG_ATA)		+= ata/
 obj-$(CONFIG_FUSION)		+= message/
 obj-$(CONFIG_FIREWIRE)		+= firewire/



