From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] Typo in linux_drivers_scsi_seagate.c
Date: Mon, 15 Jul 2002 17:48:06 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020715082112.10B2542A3@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org

From: (via Rusty) James Mayer <james@cobaltmountain.com>


--- trivial-2.5.25/drivers/scsi/seagate.c.orig	Mon Jul 15 17:03:05 2002
+++ trivial-2.5.25/drivers/scsi/seagate.c	Mon Jul 15 17:03:05 2002
@@ -21,7 +21,7 @@
  * linux 2.1.112, simplified some #defines etc. <pavel@ucw.cz>
  *
  * Aug 2000 - aeb - deleted seagate_st0x_biosparam(). It would try to
- * read the physical disk geometry, a bad mistake. Of course it doesnt
+ * read the physical disk geometry, a bad mistake. Of course it doesn't
  * matter much what geometry one invents, but on large disks it
  * returned 256 (or more) heads, causing all kind of failures.
  * Of course this means that people might see a different geometry now,
-- 
  Don't blame me: the Monkey is driving
