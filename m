From: mike.miller@hp.com
Subject: [PATCH 2/2] cciss: change version to 2.6.10
Date: Fri, 9 Dec 2005 10:24:25 -0600
Message-ID: <20051209162425.GB23618@beardog.cca.cpqcorp.net>
Reply-To: mikem@beardog.cca.cpqcorp.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:1416 "EHLO
	ccerelbas01.cce.hp.com") by vger.kernel.org with ESMTP
	id S932167AbVLIQZL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 11:25:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This patch changes the driver version to 2.6.10 and extends the copyright
into 2006. Please apply along with the MSI/MSI-X patch I submitted.

Signed-off-by: Mike Miller <mike.miller@hp.com>
--------------------------------------------------------------------------------
 cciss.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ede990f..17b3057 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1,6 +1,6 @@
 /*
  *    Disk Array driver for HP SA 5xxx and 6xxx Controllers
- *    Copyright 2000, 2005 Hewlett-Packard Development Company, L.P.
+ *    Copyright 2000, 2006 Hewlett-Packard Development Company, L.P.
  *
  *    This program is free software; you can redistribute it and/or modify
  *    it under the terms of the GNU General Public License as published by
@@ -47,12 +47,12 @@
 #include <linux/completion.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
-#define DRIVER_NAME "HP CISS Driver (v 2.6.8)"
-#define DRIVER_VERSION CCISS_DRIVER_VERSION(2,6,8)
+#define DRIVER_NAME "HP CISS Driver (v 2.6.10)"
+#define DRIVER_VERSION CCISS_DRIVER_VERSION(2,6,10)
 
 /* Embedded module documentation macros - see modules.h */
 MODULE_AUTHOR("Hewlett-Packard Company");
-MODULE_DESCRIPTION("Driver for HP Controller SA5xxx SA6xxx version 2.6.8");
+MODULE_DESCRIPTION("Driver for HP Controller SA5xxx SA6xxx version 2.6.10");
 MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312 SA641 SA642 SA6400"
 			" SA6i P600 P800 P400 P400i E200 E200i");
 MODULE_LICENSE("GPL");
