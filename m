From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] drivers_scsi_ppa.c, typo: the the
Date: Wed, 28 Aug 2002 18:07:30 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020828032403.B5F682C33F@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: David Campbell <campbell@torque.net>, linux-scsi@vger.kernel.org

From:  James Mayer <james@cobaltmountain.com>


--- trivial-2.5.32/drivers/scsi/ppa.c.orig	2002-08-28 17:54:25.000000000 +1000
+++ trivial-2.5.32/drivers/scsi/ppa.c	2002-08-28 17:54:25.000000000 +1000
@@ -993,7 +993,7 @@
 }
 
 /*
- * Apparently the the disk->capacity attribute is off by 1 sector 
+ * Apparently the disk->capacity attribute is off by 1 sector 
  * for all disk drives.  We add the one here, but it should really
  * be done in sd.c.  Even if it gets fixed there, this will still
  * work.
-- 
  Don't blame me: the Monkey is driving
  File: James Mayer <james@cobaltmountain.com>: drivers_scsi_ppa.c, typo: the the
