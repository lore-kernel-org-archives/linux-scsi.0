From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.5 patch] remove an unused function from wd7000.c
Date: Sun, 22 Jun 2003 02:05:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030622000538.GM23337@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:29928 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S264461AbTFUXvg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 19:51:36 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@rustcorp.com.au

The patch below removes an unused function from drivers/scsi/wd7000.c .

I've tested the compilation with 2.5.72-mm2.

cu
Adrian

--- linux-2.5.72-mm2/drivers/scsi/wd7000.c.old	2003-06-22 01:07:59.000000000 +0200
+++ linux-2.5.72-mm2/drivers/scsi/wd7000.c	2003-06-22 01:08:34.000000000 +0200
@@ -1605,22 +1605,6 @@
 }
 
 /*
- *  I have absolutely NO idea how to do an abort with the WD7000...
- */
-static int wd7000_abort(Scsi_Cmnd * SCpnt)
-{
-	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
-
-	if (inb(host->iobase + ASC_STAT) & INT_IM) {
-		printk("wd7000_abort: lost interrupt\n");
-		wd7000_intr_handle(host->irq, NULL, NULL);
-		return FAILED;
-	}
-	return FAILED;
-}
-
-
-/*
  *  I also have no idea how to do a reset...
  */
 
