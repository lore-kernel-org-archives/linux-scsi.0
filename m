From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/2] cciss: bump version to .20 to reflect new HW support
Date: Tue, 10 Jun 2008 11:14:04 -0500
Message-ID: <20080610161404.GB6808@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:17782 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYFJQOF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 12:14:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, andrew.patterson@hp.com, justin.chen@hp.com

PATCH 2/2
This patch bumps the driver version to 3.6.20 to reflect the new hardware
support from patch 1 of this set. Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ced904d..c21a5a9 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -53,16 +53,16 @@
 #include <linux/scatterlist.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
-#define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
-#define DRIVER_VERSION CCISS_DRIVER_VERSION(3,6,14)
+#define DRIVER_NAME "HP CISS Driver (v 3.6.20)"
+#define DRIVER_VERSION CCISS_DRIVER_VERSION(3, 6, 20)
 
 /* Embedded module documentation macros - see modules.h */
 MODULE_AUTHOR("Hewlett-Packard Company");
-MODULE_DESCRIPTION("Driver for HP Controller SA5xxx SA6xxx version 3.6.14");
+MODULE_DESCRIPTION("Driver for HP Smart Array Controllers");
 MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312 SA641 SA642 SA6400"
 			" SA6i P600 P800 P400 P400i E200 E200i E500 P700m"
 			" Smart Array G2 Series SAS/SATA Controllers");
-MODULE_VERSION("3.6.14");
+MODULE_VERSION("3.6.20");
 MODULE_LICENSE("GPL");
 
 #include "cciss_cmd.h"
