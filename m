From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] drivers_scsi_imm.c, typo: the the
Date: Wed, 28 Aug 2002 18:07:28 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020828032404.08FDC2C423@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: David Campbell <campbell@torque.net>, linux-scsi@vger.kernel.org

From:  James Mayer <james@cobaltmountain.com>


--- trivial-2.5.32/drivers/scsi/imm.c.orig	2002-08-28 17:54:24.000000000 +1000
+++ trivial-2.5.32/drivers/scsi/imm.c	2002-08-28 17:54:24.000000000 +1000
@@ -1112,7 +1112,7 @@
 }
 
 /*
- * Apparently the the disk->capacity attribute is off by 1 sector 
+ * Apparently the disk->capacity attribute is off by 1 sector 
  * for all disk drives.  We add the one here, but it should really
  * be done in sd.c.  Even if it gets fixed there, this will still
  * work.
-- 
  Don't blame me: the Monkey is driving
  File: James Mayer <james@cobaltmountain.com>: drivers_scsi_imm.c, typo: the the
