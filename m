From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH -next] advansys: Add missing include file
Date: Fri,  5 Jun 2015 07:12:39 -0700
Message-ID: <1433513559-5652-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:44771 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423157AbbFEOMn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2015 10:12:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>

Fix:

drivers/scsi/advansys.c: In function 'adv_isr_callback':
drivers/scsi/advansys.c:6089:3: error:
		implicit declaration of function 'dma_pool_free'
drivers/scsi/advansys.c: In function 'adv_get_sglist':
drivers/scsi/advansys.c:7654:3: error:
		implicit declaration of function 'dma_pool_alloc'
drivers/scsi/advansys.c: In function 'advansys_wide_init_chip':
drivers/scsi/advansys.c:10866:2: error:
		implicit declaration of function 'dma_pool_create'

Fixes: 0ce538226b7a ("advansys: Use dma_pool for sg elements")
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/scsi/advansys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 14d3aa54daa5..af2cb5e9e3f7 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -36,6 +36,7 @@
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
 #include <linux/firmware.h>
 
 #include <asm/io.h>
-- 
2.1.0

