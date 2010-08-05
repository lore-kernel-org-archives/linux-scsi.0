From: David Miller <davem@davemloft.net>
Subject: [PATCH] arcmsr_hba: Missing slab.h include
Date: Wed, 04 Aug 2010 22:58:27 -0700 (PDT)
Message-ID: <20100804.225827.52205141.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45846
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757750Ab0HEF6I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 01:58:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by sunset.davemloft.net (Postfix) with ESMTP id 4CEF624C090
	for <linux-scsi@vger.kernel.org>; Wed,  4 Aug 2010 22:58:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 95a895d..c8dc392 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -56,6 +56,7 @@
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/timer.h>
+#include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <asm/dma.h>
