From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] warning cleanup for drivers_scsi_dpt_i2o.c
Date: Wed, 07 Aug 2002 12:16:06 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807043058.0E7204B61@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

[ Completely unused ]
From:  Eric Sandeen <sandeen@sgi.com>


--- trivial-2.4.20-pre1/drivers/scsi/dpt_i2o.c.orig	2002-08-07 10:57:24.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/dpt_i2o.c	2002-08-07 10:57:24.000000000 +1000
@@ -110,10 +110,6 @@
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
