From: Christoph Hellwig <hch@lst.de>
Subject: [PACH] mesh is ppc32-only
Date: Wed, 25 Aug 2004 18:40:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040825164043.GB12679@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:30653 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268121AbUHYQkp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 12:40:45 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

mesh is only present on older 32bit pmac boards and doesn't compile
on ppc64.


--- 1.78/drivers/scsi/Kconfig	2004-07-27 00:15:55 +02:00
+++ edited/drivers/scsi/Kconfig	2004-08-25 18:26:15 +02:00
@@ -1462,7 +1462,7 @@
 
 config SCSI_MESH
 	tristate "MESH (Power Mac internal SCSI) support"
-	depends on PPC_PMAC && SCSI
+	depends on PPC32 && PPC_PMAC && SCSI
 	help
 	  Many Power Macintoshes and clones have a MESH (Macintosh Enhanced
 	  SCSI Hardware) SCSI bus adaptor (the 7200 doesn't, but all of the
