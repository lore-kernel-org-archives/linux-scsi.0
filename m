From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] don't mark aacraid as experimental
Date: Mon, 20 Sep 2004 17:38:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040920153851.GB27741@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:40910 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266708AbUITPix (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 11:38:53 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


===== drivers/scsi/Kconfig 1.83 vs edited =====
--- 1.83/drivers/scsi/Kconfig	2004-09-06 15:26:43 +02:00
+++ edited/drivers/scsi/Kconfig	2004-09-19 19:26:01 +02:00
@@ -313,8 +313,8 @@
 	  module will be called aha1740.
 
 config SCSI_AACRAID
-	tristate "Adaptec AACRAID support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SCSI && PCI
+	tristate "Adaptec AACRAID support"
+	depends on SCSI && PCI
 
 source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"
 
