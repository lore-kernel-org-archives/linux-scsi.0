From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] warning cleanup for drivers_scsi_fdomain.c
Date: Wed, 07 Aug 2002 12:16:54 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807043054.2890E4AD7@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

[ Declared to return int, even though caller currently ignores it, it
  should return "success" here. ]
 
From:  Eric Sandeen <sandeen@sgi.com>


--- trivial-2.4.20-pre1/drivers/scsi/fdomain.c.orig	2002-08-07 10:57:24.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/fdomain.c	2002-08-07 10:57:24.000000000 +1000
@@ -2041,7 +2041,7 @@
 		free_irq(shpnt->irq, shpnt);
 	if (shpnt->io_port && shpnt->n_io_port)
 		release_region(shpnt->io_port, shpnt->n_io_port);
-
+	return 0;
 }
 
 MODULE_LICENSE("GPL");
-- 
  Don't blame me: the Monkey is driving
