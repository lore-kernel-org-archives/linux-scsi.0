From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] don't mark the initio 9100 driver broken
Date: Sat, 25 Sep 2004 15:50:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040925135023.GA19907@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45030 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269335AbUIYNu0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Sep 2004 09:50:26 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Users report it just works fine, it has basic EH and compiles without
warnings even on ppc64.


--- 1.82/drivers/scsi/Kconfig	2004-08-25 18:26:15 +02:00
+++ edited/drivers/scsi/Kconfig	2004-09-25 15:45:43 +02:00
@@ -783,7 +783,7 @@
 
 config SCSI_INITIO
 	tristate "Initio 9100U(W) support"
-	depends on PCI && SCSI && BROKEN
+	depends on PCI && SCSI
 	help
 	  This is support for the Initio 91XXU(W) SCSI host adapter.  Please
 	  read the SCSI-HOWTO, available from
