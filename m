From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] some HBA compile warning fixes
Date: Thu, 21 Nov 2002 16:12:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121161217.A14037@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.14/drivers/scsi/NCR53c406a.c	Mon Nov 18 08:11:24 2002
+++ edited/drivers/scsi/NCR53c406a.c	Thu Nov 21 14:52:42 2002
@@ -55,7 +55,6 @@
 #include <linux/spinlock.h>
 #include "scsi.h"
 #include "hosts.h"
-#include "NCR53c406a.h"
 
 /* ============================================================= */
 
--- 1.12/drivers/scsi/megaraid.h	Wed Oct 30 20:11:32 2002
+++ edited/drivers/scsi/megaraid.h	Thu Nov 21 15:36:25 2002
@@ -974,13 +974,11 @@
 			   mega_ioctl_mbox * mbox);
 #endif
 
-static int megadev_open (struct inode *, struct file *);
 static int megadev_ioctl_entry (struct inode *, struct file *,
 				unsigned int, unsigned long);
 static int megadev_ioctl (struct inode *, struct file *,
 			  unsigned int, unsigned long);
 static mega_scb *megadev_doioctl (mega_host_config *, Scsi_Cmnd *);
-static int megadev_close (struct inode *, struct file *);
 static void megadev_ioctl_done (Scsi_Cmnd *);
 static int mega_init_scb (mega_host_config *);
 static void enq_scb_freelist (mega_host_config *, mega_scb *,
