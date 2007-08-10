From: akpm@linux-foundation.org
Subject: [patch 11/30] drivers/scsi/g_NCR5380.c: "NCR53C400_PSEUDO_DMA" is not  defined
Date: Fri, 10 Aug 2007 14:50:39 -0700
Message-ID: <200708102150.l7ALodiB011348@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36348 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbXHJV53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:57:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, nix.or.die@googlemail.com

From: Gabriel C <nix.or.die@googlemail.com>

Got this warning with current git:

...

In file included from drivers/scsi/g_NCR5380_mmio.c:9:
drivers/scsi/g_NCR5380.c:559:5: warning: "NCR53C400_PSEUDO_DMA" is not defined

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/g_NCR5380.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/g_NCR5380.c~drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c~drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not
+++ a/drivers/scsi/g_NCR5380.c
@@ -556,7 +556,7 @@ generic_NCR5380_biosparam(struct scsi_de
 }
 #endif
 
-#if NCR53C400_PSEUDO_DMA
+#ifdef NCR53C400_PSEUDO_DMA
 
 /**
  *	NCR5380_pread		-	pseudo DMA read
_
