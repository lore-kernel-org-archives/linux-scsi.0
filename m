From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove unused includes and misleading comments from scsi_lib.c
Date: Sun, 17 Nov 2002 23:54:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117235449.B9824@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Some of that stuff might have been right for 2.4, but..

(and btw, scsi_lib is pretty misleading, what about reusing scsi_queue.c?)


--- 1.46/drivers/scsi/scsi_lib.c	Thu Nov 14 18:09:17 2002
+++ edited/drivers/scsi/scsi_lib.c	Sun Nov 17 21:37:05 2002
@@ -7,50 +7,18 @@
  *                        of people at Linux Expo.
  */
 
-/*
- * The fundamental purpose of this file is to contain a library of utility
- * routines that can be used by low-level drivers.   Ultimately the idea
- * is that there should be a sufficiently rich number of functions that it
- * would be possible for a driver author to fashion a queueing function for
- * a low-level driver if they wished.   Note however that this file also
- * contains the "default" versions of these functions, as we don't want to
- * go through and retrofit queueing functions into all 30 some-odd drivers.
- */
-
-#include <linux/module.h>
-
-#include <linux/sched.h>
-#include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/bio.h>
-#include <linux/ioport.h>
 #include <linux/kernel.h>
-#include <linux/stat.h>
 #include <linux/blk.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/completion.h>
 
-
-#define __KERNEL_SYSCALLS__
-
-#include <linux/unistd.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/dma.h>
-
 #include "scsi.h"
 #include "hosts.h"
 #include <scsi/scsi_ioctl.h>
 
 /*
- * This entire source file deals with the new queueing code.
- */
-
-/*
  * Function:    scsi_insert_special_cmd()
  *
  * Purpose:     Insert pre-formed command into request queue.
