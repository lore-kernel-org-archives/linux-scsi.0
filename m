From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] qla1280: update changelog
Date: Thu, 10 Feb 2005 17:00:53 +0100
Message-ID: <20050210160053.GC8743@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from verein.lst.de ([213.95.11.210]:5849 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262156AbVBJQA7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 11:00:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org

--- 1.72/drivers/scsi/qla1280.c	2004-10-22 06:20:31 +02:00
+++ edited/drivers/scsi/qla1280.c	2005-02-10 13:42:44 +01:00
@@ -20,6 +20,9 @@
 #define QLA1280_VERSION      "3.25"
 /*****************************************************************************
     Revision History:
+    Rev  3.25.1, February 10, 2005 Christoph Hellwig
+	- use pci_map_single to map non-S/G requests
+	- remove qla1280_proc_info
     Rev  3.25, September 28, 2004, Christoph Hellwig
 	- add support for ISP1020/1040
 	- don't include "scsi.h" anymore for 2.6.x
