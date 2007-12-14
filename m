From: akpm@linux-foundation.org
Subject: [patch 20/30] drivers/scsi/sgiwd93.c: export sgiwd93_reset()
Date: Thu, 13 Dec 2007 16:14:23 -0800
Message-ID: <200712140014.lBE0ENjc026234@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762465AbXLNATr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:19:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, ralf@linux-mips.org

From: Andrew Morton <akpm@linux-foundation.org>

mips allmodconfig:

ERROR: "sgiwd93_reset" [drivers/scsi/wd33c93.ko] undefined!

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sgiwd93.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/sgiwd93.c~drivers-scsi-sgiwd93c-export-sgiwd93_reset drivers/scsi/sgiwd93.c
--- a/drivers/scsi/sgiwd93.c~drivers-scsi-sgiwd93c-export-sgiwd93_reset
+++ a/drivers/scsi/sgiwd93.c
@@ -159,6 +159,7 @@ void sgiwd93_reset(unsigned long base)
 	udelay(50);
 	hregs->ctrl = 0;
 }
+EXPORT_SYMBOL_GPL(sgiwd93_reset);
 
 static inline void init_hpc_chain(struct hpc_data *hd)
 {
_
