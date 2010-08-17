From: David Miller <davem@davemloft.net>
Subject: [PATCH RESEND] arcmsr_hba: Missing slab.h include
Date: Mon, 16 Aug 2010 21:20:07 -0700 (PDT)
Message-ID: <20100816.212007.193698272.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---

Linus please merge this directly, I think giving 2 weeks for a
maintainer to pick up a trivial build fix like this is sufficient.

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
