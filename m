From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] reparent scsi new-EH threads to init
Date: Tue, 30 Jul 2002 12:26:56 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020730030326.56AF14429@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org

From:  Christoph Hellwig <hch@lst.de>

(Included in 2.4)

--- trivial-2.5.29/drivers/scsi/scsi_error.c.orig	Tue Jul 30 12:15:08 2002
+++ trivial-2.5.29/drivers/scsi/scsi_error.c	Tue Jul 30 12:15:08 2002
@@ -1878,6 +1878,7 @@
 	 */
 
 	daemonize();
+	reparent_to_init();
 
 	/*
 	 * Set the name of this process.
-- 
  Don't blame me: the Monkey is driving
