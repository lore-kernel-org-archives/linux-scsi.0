From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] reparent scsi new-EH threads to init
Date: Fri, 26 Jul 2002 16:46:03 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020726071548.210714802@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org

From:  Christoph Hellwig <hch@lst.de>

(Included in 2.4)

--- trivial-2.5.28/drivers/scsi/scsi_error.c.orig	Fri Jul 26 16:37:01 2002
+++ trivial-2.5.28/drivers/scsi/scsi_error.c	Fri Jul 26 16:37:01 2002
@@ -1878,6 +1878,7 @@
 	 */
 
 	daemonize();
+	reparent_to_init();
 
 	/*
 	 * Set the name of this process.
-- 
  Don't blame me: the Monkey is driving
