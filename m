From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove useless includes from scsi.h
Date: Thu, 21 Nov 2002 02:58:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121025850.A9137@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.44/drivers/scsi/scsi.h	Sun Nov 17 16:44:35 2002
+++ edited/drivers/scsi/scsi.h	Thu Nov 21 01:54:42 2002
@@ -15,23 +15,10 @@
 #ifndef _SCSI_H
 #define _SCSI_H
 
-#include <linux/config.h>	/* for CONFIG_SCSI_LOGGING */
-#include <linux/devfs_fs_kernel.h>
-#include <linux/proc_fs.h>
-#include <linux/init.h>
-
-
-/*
- * Some of the public constants are being moved to this file.
- * We include it here so that what came from where is transparent.
- */
+#include <linux/config.h>	    /* for CONFIG_SCSI_LOGGING */
+#include <linux/devfs_fs_kernel.h>  /* some morons don't know struct pointers */
 #include <scsi/scsi.h>
 
-#include <linux/random.h>
-
-#include <asm/hardirq.h>
-#include <asm/scatterlist.h>
-#include <asm/io.h>
 
 /*
  * These are the values that the SCpnt->sc_data_direction and 
@@ -396,6 +383,7 @@
  * Forward-declaration of structs for prototypes.
  */
 struct Scsi_Host;
+struct scatterlist;
 
 /*
  * Add some typedefs so that we can prototyope a bunch of the functions.
@@ -551,7 +541,7 @@
 	unsigned flags;
 };
 
-extern struct dev_info scsi_static_device_list[] __initdata;
+extern struct dev_info scsi_static_device_list[];
 
 /*
  * scsi_dev_info_list: structure to hold black/white listed devices.
