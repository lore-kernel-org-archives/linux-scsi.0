From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] mark qlogicfc broken
Date: Thu, 10 Feb 2005 19:18:15 +0100
Message-ID: <20050210181815.GB11818@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from verein.lst.de ([213.95.11.210]:26589 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262185AbVBJSSS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 13:18:18 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

The hardware is supported by qla2xxx which is much better (and
maintained) driver.  Keeping the driver around confuses people to
actually use it with severe results, e.g.

	http://marc.theaimsgroup.com/?l=linux-kernel&m=110656624623547&w=2


--- 1.95/drivers/scsi/Kconfig	2005-01-28 18:14:29 +01:00
+++ edited/drivers/scsi/Kconfig	2005-02-10 14:59:56 +01:00
@@ -1270,7 +1248,7 @@
 
 config SCSI_QLOGIC_FC
 	tristate "Qlogic ISP FC SCSI support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && BROKEN
 	help
 	  This is a driver for the QLogic ISP2100 SCSI-FCP host adapter.
 
