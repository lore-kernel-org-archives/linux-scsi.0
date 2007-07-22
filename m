From: Gabriel C <nix.or.die@googlemail.com>
Subject: [PATCH] drivers/scsi/g_NCR5380.c - "NCR53C400_PSEUDO_DMA" is not
 defined
Date: Sun, 22 Jul 2007 17:19:49 +0200
Message-ID: <46A37595.2010305@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:6409 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbXGVPWI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 11:22:08 -0400
Received: by ug-out-1314.google.com with SMTP id j3so974366ugf
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jul 2007 08:22:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

Hi,

got this warning with current git :

...

In file included from drivers/scsi/g_NCR5380_mmio.c:9:
drivers/scsi/g_NCR5380.c:559:5: warning: "NCR53C400_PSEUDO_DMA" is not defined

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
---

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 880f70d..607336f 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -556,7 +556,7 @@ generic_NCR5380_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 }
 #endif
 
-#if NCR53C400_PSEUDO_DMA
+#ifdef NCR53C400_PSEUDO_DMA
 
 /**
  *	NCR5380_pread		-	pseudo DMA read
