From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] unexport scsi_host_get_next
Date: Mon, 21 Apr 2003 11:59:07 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030421115907.B24845@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:61453 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263800AbTDUJrH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 05:47:07 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

No drivers are using it anymore, and having this private to the
midlayer should make proper shost refcounting easier.


--- 1.30/drivers/scsi/scsi_syms.c	Mon Mar 24 07:14:51 2003
+++ edited/drivers/scsi/scsi_syms.c	Mon Apr 21 10:10:29 2003
@@ -92,7 +92,6 @@
 /*
  * These are here only while I debug the rest of the scsi stuff.
  */
-EXPORT_SYMBOL(scsi_host_get_next);
 EXPORT_SYMBOL(scsi_host_hn_get);
 EXPORT_SYMBOL(scsi_host_put);
 EXPORT_SYMBOL(scsi_device_types);
