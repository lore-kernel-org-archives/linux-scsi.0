From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] drivers_scsi_imm.c, typo: the the
Date: Tue, 20 Aug 2002 18:58:09 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020820041036.BF1902C496@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: David Campbell <campbell@torque.net>, linux-scsi@vger.kernel.org

[ David: trivial typo, please push to Marcelo.  Thanks ]
From:  James Mayer <james@cobaltmountain.com>


--- trivial-2.4.20-pre4/drivers/scsi/imm.c.orig	2002-08-20 18:00:45.000000000 +1000
+++ trivial-2.4.20-pre4/drivers/scsi/imm.c	2002-08-20 18:00:45.000000000 +1000
@@ -1120,7 +1120,7 @@
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
