From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove an outdated comment from sym2
Date: Tue, 26 Aug 2003 18:59:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030826165940.GA6620@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:25522 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262756AbTHZQ7n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2003 12:59:43 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org


--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri Aug  8 11:11:33 2003
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri Aug  8 11:11:33 2003
@@ -83,19 +83,6 @@
 void sym_udelay(int us) { udelay(us); }
 void sym_mdelay(int ms) { mdelay(ms); }
 
-/*
- *  SMP threading.
- *
- *  The whole SCSI sub-system under Linux is basically single-threaded.
- *  Everything, including low-level driver interrupt routine, happens 
- *  with the `io_request_lock' held.
- *  The sym53c8xx-1.x drivers series ran their interrupt code using a 
- *  spin mutex per controller. This added complexity without improving 
- *  scalability significantly. the sym-2 driver still use a spinlock 
- *  per controller for safety, but basically runs with the damned 
- *  io_request_lock held.
- */
-
 spinlock_t sym53c8xx_lock = SPIN_LOCK_UNLOCKED;
 
 #define	SYM_LOCK_DRIVER(flags)    spin_lock_irqsave(&sym53c8xx_lock, flags)
