From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.5 patch] small cleanup for drivers/scsi/inia100.*
Date: Sat, 18 Jan 2003 18:10:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030118171010.GI10647@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The patch below contains the following small cleanup for 
drivers/scsi/inia100.{h,c}:
- removed unused TRUE/FALSE
- removed unused CVT_LINUX_VERSION and #include <linux/version.h>

I've tested the compilation with 2.5.59.

cu
Adrian

--- linux-2.5.59-full/drivers/scsi/inia100.h.old	2003-01-18 17:59:24.000000000 +0100
+++ linux-2.5.59-full/drivers/scsi/inia100.h	2003-01-18 18:01:50.000000000 +0100
@@ -63,14 +63,6 @@
  *		   merged them into a single header used by both .c files.
  ****************************************************************************/
 
-#ifndef	CVT_LINUX_VERSION
-#define	CVT_LINUX_VERSION(V,P,S)	(((V) * 65536) + ((P) * 256) + (S))
-#endif
-
-#ifndef	LINUX_VERSION_CODE
-#include <linux/version.h>
-#endif
-
 #include <linux/config.h>
 #include <linux/types.h>
 #include <linux/pci.h>
@@ -117,12 +109,6 @@
 #ifndef NULL
 #define NULL     0		/* zero          */
 #endif
-#ifndef TRUE
-#define TRUE     (1)		/* boolean true  */
-#endif
-#ifndef FALSE
-#define FALSE    (0)		/* boolean false */
-#endif
 #ifndef FAILURE
 #define FAILURE  (-1)
 #endif
--- linux-2.5.59-full/drivers/scsi/inia100.c.old	2003-01-18 18:03:23.000000000 +0100
+++ linux-2.5.59-full/drivers/scsi/inia100.c	2003-01-18 18:03:46.000000000 +0100
@@ -67,12 +67,6 @@
  *          - Fix allocation of scsi host structs and private data
  **************************************************************************/
 
-#define CVT_LINUX_VERSION(V,P,S)        (V * 65536 + P * 256 + S)
-
-#ifndef LINUX_VERSION_CODE
-#include <linux/version.h>
-#endif
-
 #include <linux/module.h>
 
 #include <linux/errno.h>
