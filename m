From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] small sym2 sparse fix
Date: Sat, 9 Oct 2004 15:43:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041009134354.GA20025@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:11667 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266837AbUJINn4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2004 09:43:56 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.49/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-09-13 14:36:39 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-10-09 14:47:02 +02:00
@@ -2028,7 +2028,7 @@
 {
 	unsigned long base_2_c = device->s.base_2_c;
 	unsigned int ram_size, ram_val;
-	void *ram_ptr;
+	void __iomem *ram_ptr;
 
 	if (!base_2_c)
 		return 0;
