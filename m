From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] mark eata_pio broken
Date: Thu, 10 Feb 2005 19:16:55 +0100
Message-ID: <20050210181655.GA11818@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from verein.lst.de ([213.95.11.210]:23261 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262183AbVBJSQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 13:16:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

it oopses when trying to use it with my SmartRaid IV card, it's a mess
and the only hardware supported by it but not the eata driver are two
10-year old ISA boards.


--- 1.95/drivers/scsi/Kconfig	2005-01-28 18:14:29 +01:00
+++ edited/drivers/scsi/Kconfig	2005-02-10 14:59:56 +01:00
@@ -611,7 +611,7 @@
 
 config SCSI_EATA_PIO
 	tristate "EATA-PIO (old DPT PM2001, PM2012A) support"
-	depends on (ISA || EISA || PCI) && SCSI
+	depends on (ISA || EISA || PCI) && SCSI && BROKEN
 	---help---
 	  This driver supports all EATA-PIO protocol compliant SCSI Host
 	  Adapters like the DPT PM2001 and the PM2012A.  EATA-DMA compliant
