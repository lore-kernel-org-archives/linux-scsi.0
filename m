From: David Mosberger <davidm@napali.hpl.hp.com>
Subject: small patch for sym53c8xx_2
Date: Wed, 18 Jun 2003 13:46:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <16112.53170.851207.542028@napali.hpl.hp.com>
Reply-To: davidm@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel10.hp.com ([156.153.255.245]:40863 "EHLO palrel10.hp.com")
	by vger.kernel.org with ESMTP id S265491AbTFRUcr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2003 16:32:47 -0400
List-Id: linux-scsi@vger.kernel.org
To: groudier@free.fr
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I thought we had an agreement for a long time already that the use of
dma64_addr_t in the sym53c8xx_2 driver was wrong, but it's still
there.

Thanks,

	--david

diff -Nru a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	Wed Jun 18 13:32:51 2003
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	Wed Jun 18 13:32:51 2003
@@ -295,11 +295,7 @@
 #ifndef SYM_LINUX_DYNAMIC_DMA_MAPPING
 typedef u_long		bus_addr_t;
 #else
-#if	SYM_CONF_DMA_ADDRESSING_MODE > 0
-typedef dma64_addr_t	bus_addr_t;
-#else
 typedef dma_addr_t	bus_addr_t;
-#endif
 #endif
 
 /*
