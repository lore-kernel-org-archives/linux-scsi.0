From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.5 patch] small cleanup in drivers/scsi/i91uscsi.h
Date: Sat, 18 Jan 2003 17:58:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030118165809.GH10647@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The patch below does the follwojng small updates in 
drivers/scsi/i91uscsi.h:
- remove #if for kernel 2.0
- remove unused #define TRUE/FALSE

cu
Adrian

--- linux-2.5.59-full/drivers/scsi/i91uscsi.h.old	2003-01-18 17:53:01.000000000 +0100
+++ linux-2.5.59-full/drivers/scsi/i91uscsi.h	2003-01-18 17:53:55.000000000 +0100
@@ -70,12 +70,6 @@
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
@@ -597,11 +591,9 @@
 	TCS HCS_Tcs[MAX_TARGETS];	/* 78 */
 	ULONG pSRB_head;	/* SRB save queue header     */
 	ULONG pSRB_tail;	/* SRB save queue tail       */
-#if LINUX_VERSION_CODE >= CVT_LINUX_VERSION(2,1,95)
 	spinlock_t HCS_AvailLock;
 	spinlock_t HCS_SemaphLock;
 	spinlock_t pSRB_lock;	/* SRB queue lock            */
-#endif
 } HCS;
 
 /* Bit Definition for HCB_Config */
