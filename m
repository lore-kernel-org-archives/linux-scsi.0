From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.5 patch] small cleanup for drivers/scsi/ini9100u.*
Date: Sat, 11 Jan 2003 18:05:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111170556.GP10486@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

The patch below removes some no longer needed #define's from 
drivers/scsi/ini9100u.* .

cu
Adrian


--- linux-2.5.56/drivers/scsi/ini9100u.h.old	2003-01-11 17:57:40.000000000 +0100
+++ linux-2.5.56/drivers/scsi/ini9100u.h	2003-01-11 17:59:31.000000000 +0100
@@ -67,13 +67,6 @@
  *		- Added PCI_ID structure
  **************************************************************************/
 
-#ifndef	CVT_LINUX_VERSION
-#define	CVT_LINUX_VERSION(V,P,S)	(((V) * 65536) + ((P) * 256) + (S))
-#endif
-
-#ifndef	LINUX_VERSION_CODE
-#include <linux/version.h>
-#endif
 #include <linux/types.h>
 
 extern int i91u_detect(Scsi_Host_Template *);
@@ -130,15 +123,6 @@
 #ifndef NULL
 #define NULL     0		/* zero          */
 #endif
-#ifndef TRUE
-#define TRUE     (1)		/* boolean true  */
-#endif
-#ifndef FALSE
-#define FALSE    (0)		/* boolean false */
-#endif
-#ifndef FAILURE
-#define FAILURE  (-1)
-#endif
 
 #define i91u_MAXQUEUE		2
 #define TOTAL_SG_ENTRY		32
--- linux-2.5.56/drivers/scsi/ini9100u.c.old	2003-01-11 17:57:46.000000000 +0100
+++ linux-2.5.56/drivers/scsi/ini9100u.c	2003-01-11 17:59:57.000000000 +0100
@@ -106,14 +106,8 @@
  *		- Changed the assumption that HZ = 100
  **************************************************************************/
 
-#define CVT_LINUX_VERSION(V,P,S)        (V * 65536 + P * 256 + S)
-
 #error Please convert me to Documentation/DMA-mapping.txt
 
-#ifndef LINUX_VERSION_CODE
-#include <linux/version.h>
-#endif
-
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
