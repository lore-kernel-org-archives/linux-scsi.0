From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] mca_53c9x needs CONFIG_MCA_LEGACY
Date: Sat, 8 May 2004 19:32:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040508173235.GA1572@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:61416 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263979AbUEHRci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 May 2004 13:32:38 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.63/drivers/scsi/Kconfig	Tue Apr 13 03:27:07 2004
+++ edited/drivers/scsi/Kconfig	Wed May  5 09:52:38 2004
@@ -1100,7 +1100,7 @@
 
 config SCSI_MCA_53C9X
 	tristate "NCR MCA 53C9x SCSI support"
-	depends on MCA && SCSI && BROKEN_ON_SMP
+	depends on MCA_LEGACY && SCSI && BROKEN_ON_SMP
 	help
 	  Some MicroChannel machines, notably the NCR 35xx line, use a SCSI
 	  controller based on the NCR 53C94.  This driver will allow use of
