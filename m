From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update mips driver Kconfig bits
Date: Wed, 19 Jan 2005 12:45:08 +0100
Message-ID: <20050119114508.GB11133@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:56788 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261695AbVASLpS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 06:45:18 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

--- 1.94/drivers/scsi/Kconfig	2005-01-15 23:31:06 +01:00
+++ edited/drivers/scsi/Kconfig	2005-01-16 11:44:56 +01:00
@@ -225,14 +225,14 @@
 
 config SCSI_DECNCR
 	tristate "DEC NCR53C94 Scsi Driver"
-	depends on DECSTATION && TC && SCSI
+	depends on MACH_DECSTATION && SCSI && TC
 	help
 	  Say Y here to support the NCR53C94 SCSI controller chips on IOASIC
 	  based TURBOchannel DECstations and TURBOchannel PMAZ-A cards.
 
 config SCSI_DECSII
 	tristate "DEC SII Scsi Driver"
-	depends on DECSTATION && SCSI
+	depends on MACH_DECSTATION && SCSI && MIPS32
 
 config BLK_DEV_3W_XXXX_RAID
 	tristate "3ware 5/6/7/8xxx ATA-RAID support"
