From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.5 patch] remove unneeded #define LinuxVersionCode from sym53c416.h
Date: Fri, 17 Jan 2003 16:53:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030117155332.GD2333@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: lw_linux@hotmail.com
Cc: linux-scsi@vger.kernel.org

The patch below removes the unneeded #define LinuxVersionCode from
sym53c416.h.

Please apply
Adrian

--- linux-2.5.59-full/drivers/scsi/sym53c416.h.old	2003-01-17 11:18:24.000000000 +0100
+++ linux-2.5.59-full/drivers/scsi/sym53c416.h	2003-01-17 11:19:17.000000000 +0100
@@ -18,14 +18,6 @@
 #ifndef _SYM53C416_H
 #define _SYM53C416_H
 
-#if !defined(LINUX_VERSION_CODE)
-#include <linux/version.h>
-#endif
-
-#ifndef LinuxVersionCode
-#define LinuxVersionCode(v, p, s) (((v)<<16)+((p)<<8)+(s))
-#endif
-
 #include <linux/types.h>
 
 #define SYM53C416_SCSI_ID 7
