From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: libsas depends on HAS_DMA
Date: Mon, 11 May 2009 22:40:20 +0000
Message-ID: <200905112240.20171.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971AbZEKWkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2009 18:40:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

libsas uses the DMA mapping API, so it cannot be
built on architectures that don't support DMA.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/libsas/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index 18f33cd..59e00fa 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -24,7 +24,7 @@
 
 config SCSI_SAS_LIBSAS
 	tristate "SAS Domain Transport Attributes"
-	depends on SCSI
+	depends on SCSI && HAS_DMA
 	select SCSI_SAS_ATTRS
 	help
 	  This provides transport specific helpers for SAS drivers which
-- 
1.6.0.4

-- 


