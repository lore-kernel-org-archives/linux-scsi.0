From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] warning cleanup for drivers_scsi_dpt_i2o.c
Date: Tue, 06 Aug 2002 13:43:48 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020806035805.6463F4B65@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, deanna_bonds@adaptec.com

[ Completely unused code leaves unused warning.  If fix OK, please
  reply or push to Linus ]

From:  Eric Sandeen <sandeen@sgi.com>


--- trivial-2.5.30/drivers/scsi/dpt_i2o.c.orig	2002-08-06 13:18:04.000000000 +1000
+++ trivial-2.5.30/drivers/scsi/dpt_i2o.c	2002-08-06 13:18:04.000000000 +1000
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
