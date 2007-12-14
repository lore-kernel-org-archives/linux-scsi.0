From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 3/3] cciss: version change to 3.6.18
Date: Fri, 14 Dec 2007 16:21:50 -0600
Message-ID: <20071214222150.GC32019@roadking.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:34027 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXLNWVw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Dec 2007 17:21:52 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Patch 3 of 3

This patch bumps the driver version to 3.6.18 to reflect support for the
P700m. This matches the HP released driver version for hardware support.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/Documentation/cciss.txt b/Documentation/cciss.txt
index e65736c..0467639 100644
--- a/Documentation/cciss.txt
+++ b/Documentation/cciss.txt
@@ -21,6 +21,7 @@ This driver is known to work with the following cards:
 	* SA E200
 	* SA E200i
 	* SA E500
+	* SA P700m
 
 Detecting drive failures:
 -------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index cd5ef4a..7a0b28b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -51,15 +51,15 @@
 #include <linux/cdrom.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
-#define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
-#define DRIVER_VERSION CCISS_DRIVER_VERSION(3,6,14)
+#define DRIVER_NAME "HP CISS Driver (v 3.6.18)"
+#define DRIVER_VERSION CCISS_DRIVER_VERSION(3,6,18)
 
 /* Embedded module documentation macros - see modules.h */
 MODULE_AUTHOR("Hewlett-Packard Company");
-MODULE_DESCRIPTION("Driver for HP Controller SA5xxx SA6xxx version 3.6.14");
+MODULE_DESCRIPTION("Driver for HP Controller SA5xxx SA6xxx version 3.6.18");
 MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312 SA641 SA642 SA6400"
-			" SA6i P600 P800 P400 P400i E200 E200i E500");
-MODULE_VERSION("3.6.14");
+			" SA6i P600 P800 P400 P400i E200 E200i E500 P700m");
+MODULE_VERSION("3.6.18");
 MODULE_LICENSE("GPL");
 
 #include "cciss_cmd.h"
