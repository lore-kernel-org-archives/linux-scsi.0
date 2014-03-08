From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND][SCSI] ips: remove unused defines
Date: Sat,  8 Mar 2014 06:32:51 +0100
Message-ID: <1394256771-10751-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1386583540-5190-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:42824 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753705AbaCHFdA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Mar 2014 00:33:00 -0500
In-Reply-To: <1386583540-5190-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@adaptec.com, ipslinux@adaptec.com, JBottomley@parallels.com
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>

This patch removes unused defines from drivers/scsi/ips.h

- the min() macro is not used
- the __iomem define is no longer needed
  to compile ips.c without warnings

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/ips.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
index 45b9566b928e..26df4f6e9d70 100644
--- a/drivers/scsi/ips.h
+++ b/drivers/scsi/ips.h
@@ -88,14 +88,6 @@
 		touch_nmi_watchdog();	\
 	} while (0)
 
-   #ifndef min
-      #define min(x,y) ((x) < (y) ? x : y)
-   #endif
-
-   #ifndef __iomem       /* For clean compiles in earlier kernels without __iomem annotations */
-      #define __iomem
-   #endif
-
    #define pci_dma_hi32(a)         ((a >> 16) >> 16)
    #define pci_dma_lo32(a)         (a & 0xffffffff)
 
-- 
1.8.3.2

