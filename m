From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] SCSI: make pcmcia directory use obj-y|m instead of subdir-y|m
Date: Fri, 07 Dec 2007 22:36:23 +0900
Message-ID: <47594C57.4070006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:32127 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbXLGNgc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 08:36:32 -0500
Received: by py-out-1112.google.com with SMTP id u77so1421739pyb
        for <linux-scsi@vger.kernel.org>; Fri, 07 Dec 2007 05:36:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

subdir-y|m isn't supposed to contain modules or built-in components.
Change subdir-$(CONFIG_PCMCIA) to obj-$(CONFIG_PCMCIA).

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 2e6129f..72c8d2e 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -18,7 +18,7 @@ CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
 CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ -DGDTH_STATISTICS
 CFLAGS_seagate.o =   -DARBITRATE -DPARITY -DSEAGATE_USE_ASM
 
-subdir-$(CONFIG_PCMCIA)		+= pcmcia
+obj-$(CONFIG_PCMCIA)		+= pcmcia/
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
 obj-$(CONFIG_SCSI_TGT)		+= scsi_tgt.o
