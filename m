From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] mark qlogicisp broken
Date: Thu, 10 Feb 2005 19:18:51 +0100
Message-ID: <20050210181851.GC11818@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from verein.lst.de ([213.95.11.210]:28381 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262187AbVBJSSy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 13:18:54 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

It's lacking EH support and the hardware is supported by the qla1280
driver now.


--- 1.95/drivers/scsi/Kconfig	2005-01-28 18:14:29 +01:00
+++ edited/drivers/scsi/Kconfig	2005-02-10 14:59:56 +01:00
@@ -1249,7 +1227,7 @@
 
 config SCSI_QLOGIC_ISP
 	tristate "Qlogic ISP SCSI support (old driver)"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && BROKEN
 	---help---
 	  This driver works for all QLogic PCI SCSI host adapters (IQ-PCI,
 	  IQ-PCI-10, IQ_PCI-D) except for the PCI-basic card.  (This latter
