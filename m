From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] warning cleanup for drivers_scsi_fdomain.c
Date: Wed, 28 Aug 2002 18:03:57 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020828032403.0285A2C41E@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: alan@redhat.com, faith@cs.unc.edu, linux-scsi@vger.kernel.org

(Included in 2.4)
From:  Eric Sandeen <sandeen@sgi.com>


--- trivial-2.5.32/drivers/scsi/fdomain.c.orig	2002-08-28 17:53:51.000000000 +1000
+++ trivial-2.5.32/drivers/scsi/fdomain.c	2002-08-28 17:53:51.000000000 +1000
@@ -2042,7 +2042,7 @@
 		free_irq(shpnt->irq, shpnt);
 	if (shpnt->io_port && shpnt->n_io_port)
 		release_region(shpnt->io_port, shpnt->n_io_port);
-
+	return 0;
 }
 
 MODULE_LICENSE("GPL");
-- 
  Don't blame me: the Monkey is driving
  File: Eric Sandeen <sandeen@sgi.com>: warning cleanup for drivers_scsi_fdomain.c
