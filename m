From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] warning cleanup for drivers_scsi_dpt_i2o.c
Date: Wed, 28 Aug 2002 18:03:50 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020828032404.54BF12C150@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: deanna_bonds@adaptec.com, linux-scsi@vger.kernel.org

(Included in 2.4)
From:  Eric Sandeen <sandeen@sgi.com>


--- trivial-2.5.32/drivers/scsi/dpt_i2o.c.orig	2002-08-28 17:53:50.000000000 +1000
+++ trivial-2.5.32/drivers/scsi/dpt_i2o.c	2002-08-28 17:53:51.000000000 +1000
@@ -112,10 +112,6 @@
 static adpt_hba* hba_chain = NULL;
 static int hba_count = 0;
 
-// Debug flags to be put into the HBA flags field when initialized
-// Make sure to enable DEBUG_PRINT for these flags to work
-static unsigned long DebugFlags = HBA_FLAGS_DBG_SCAN_B | HBA_FLAGS_DBG_FLAGS_MASK;
-
 static struct file_operations adpt_fops = {
 	ioctl: adpt_ioctl,
 	open: adpt_open,
-- 
  Don't blame me: the Monkey is driving
  File: Eric Sandeen <sandeen@sgi.com>: warning cleanup for drivers_scsi_dpt_i2o.c
