From: Rusty Trivial Russell <trivial@rustcorp.com.au>
Subject: [TRIVIAL] [2.5 patch] remove an unused function from wd7000.c
Date: Thu, 04 Sep 2003 13:12:12 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030904033018.C07B42C10E@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:19392 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S264616AbTIDDaT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2003 23:30:19 -0400
List-Id: linux-scsi@vger.kernel.org
To: John Boyd <boyd@cis.ohio-state.edu>, Miroslav Zagorac <zaga@fly.cc.fer.hr>, linux-scsi@vger.kernel.org, axboe@suse.de

From:  Adrian Bunk <bunk@fs.tum.de>

  The patch below removes an unused function from drivers/scsi/wd7000.c .
  
  I've tested the compilation with 2.5.72-mm2.
  
  cu
  Adrian
  

--- trivial-2.6.0-test4-bk5/drivers/scsi/wd7000.c.orig	2003-09-04 13:01:35.000000000 +1000
+++ trivial-2.6.0-test4-bk5/drivers/scsi/wd7000.c	2003-09-04 13:01:35.000000000 +1000
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
 
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: Adrian Bunk <bunk@fs.tum.de>: [2.5 patch] remove an unused function from wd7000.c
