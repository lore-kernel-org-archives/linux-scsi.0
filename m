From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] warning cleanup for drivers_scsi_fdomain.c
Date: Tue, 06 Aug 2002 13:45:50 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020806035807.E4D4E4B6E@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: faith@redhat.com, linux-scsi@vger.kernel.org

[ Release now returns "success" ]

From:  Eric Sandeen <sandeen@sgi.com>

--- trivial-2.5.30/drivers/scsi/fdomain.c.orig	2002-08-06 13:18:04.000000000 +1000
+++ trivial-2.5.30/drivers/scsi/fdomain.c	2002-08-06 13:18:04.000000000 +1000
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
