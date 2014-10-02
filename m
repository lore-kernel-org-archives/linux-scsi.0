From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 09/29] ncr5380: Remove duplicate comments
Date: Thu, 02 Oct 2014 16:56:37 +1000
Message-ID: <20141002065630.416189473@telegraphics.com.au>
References: <20141002065628.256592712@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33722 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaJBND7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 09:03:59 -0400
Content-Disposition: inline; filename=ncr5380-remove-duplicate-comments
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

The LIMIT_TRANSFERSIZE, PSEUDO_DMA, PARITY and UNSAFE options are all
documented in the core drivers where they are used. The same goes for the
chip databook reference. Remove the duplicate comments.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/dtc.c       |   17 +----------------
 drivers/scsi/dtc.h       |   16 ----------------
 drivers/scsi/g_NCR5380.c |   16 ----------------
 drivers/scsi/g_NCR5380.h |   12 ------------
 drivers/scsi/mac_scsi.c  |   12 ------------
 drivers/scsi/mac_scsi.h  |   12 ------------
 drivers/scsi/pas16.c     |   31 -------------------------------
 drivers/scsi/pas16.h     |   12 ------------
 drivers/scsi/sun3_scsi.c |   21 ---------------------
 drivers/scsi/sun3_scsi.h |   12 ------------
 drivers/scsi/t128.c      |   23 -----------------------
 drivers/scsi/t128.h      |   12 ------------
 12 files changed, 1 insertion(+), 195 deletions(-)

Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2014-10-02 16:55:58.000000000 +1000
+++ linux/drivers/scsi/dtc.c	2014-10-02 16:56:00.000000000 +1000
@@ -19,24 +19,9 @@
  *      +1 (303) 440-4894
  *
  * DISTRIBUTION RELEASE 1.
- *
- * For more information, please consult 
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
-*/
+ */
 
 /*
- * Options : 
- * PSEUDO_DMA - enables PSEUDO-DMA hardware, should give a 3-4X performance
- * increase compared to polled I/O.
- *
- * PARITY - enable parity checking.  Not supported.
- *
- * UNSAFE - leave interrupts enabled during pseudo-DMA transfers. 
- *		You probably want this.
- *
  * The card is detected and initialized in one of several ways : 
  * 1.  Autoprobe (default) - since the board is memory mapped, 
  *     a BIOS signature is scanned for to locate the registers.
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2014-10-02 16:55:58.000000000 +1000
+++ linux/drivers/scsi/g_NCR5380.c	2014-10-02 16:56:00.000000000 +1000
@@ -20,18 +20,6 @@
  * Thomas Sailer, sailer@ife.ee.ethz.ch
  *
  * ALPHA RELEASE 1. 
- *
- * For more information, please consult 
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
  */
 
 /* 
@@ -40,10 +28,6 @@
  */
 
 /*
- * Options :
- *
- * PARITY - enable parity checking.  Not supported.
- *
  * The card is detected and initialized in one of several ways : 
  * 1.  With command line overrides - NCR5380=port,irq may be 
  *     used on the LILO command line to override the defaults.
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2014-10-02 16:55:58.000000000 +1000
+++ linux/drivers/scsi/pas16.c	2014-10-02 16:56:00.000000000 +1000
@@ -22,40 +22,9 @@
  * Media Vision
  * (510) 770-8600
  * (800) 348-7116
- * 
- * and 
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
  */
 
 /*
- * Options : 
- * LIMIT_TRANSFERSIZE - if defined, limit the pseudo-dma transfers to 512
- *      bytes at a time.  Since interrupts are disabled by default during
- *      these transfers, we might need this to give reasonable interrupt
- *      service time if the transfer size gets too large.
- *
- * PSEUDO_DMA - enables PSEUDO-DMA hardware, should give a 3-4X performance
- * increase compared to polled I/O.
- *
- * PARITY - enable parity checking.  Not supported.
- *
- * UNSAFE - leave interrupts enabled during pseudo-DMA transfers.  This
- *	    parameter comes from the NCR5380 code.  It is NOT unsafe with
- *	    the PAS16 and you should use it.  If you don't you will have
- *	    a problem with dropped characters during high speed
- *	    communications during SCSI transfers.  If you really don't
- *	    want to use UNSAFE you can try defining LIMIT_TRANSFERSIZE or
- *	    twiddle with the transfer size in the high level code.
- *
  * The card is detected and initialized in one of several ways : 
  * 1.  Autoprobe (default) - There are many different models of
  *     the Pro Audio Spectrum/Studio 16, and I only have one of
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-02 16:55:58.000000000 +1000
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-02 16:56:00.000000000 +1000
@@ -22,27 +22,6 @@
  * Copyright 1995, Russell King
  *
  * ALPHA RELEASE 1.
- *
- * For more information, please consult
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
- */
-
-
-/*
- * This is from mac_scsi.h, but hey, maybe this is useful for Sun3 too! :)
- *
- * Options :
- *
- * PARITY - enable parity checking.  Not supported.
  */
 
 #include <linux/types.h>
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2014-10-02 16:55:58.000000000 +1000
+++ linux/drivers/scsi/t128.c	2014-10-02 16:56:00.000000000 +1000
@@ -23,32 +23,9 @@
  * 5415 Randall Place
  * Fremont, CA 94538
  * 1+ (415) 770-1400, FAX 1+ (415) 770-9910
- * 
- * and 
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
  */
 
 /*
- * Options : 
- * PSEUDO_DMA - enables PSEUDO-DMA hardware, should give a 3-4X performance
- * increase compared to polled I/O.
- *
- * PARITY - enable parity checking.  Not supported.
- *
- * UNSAFE - leave interrupts enabled during pseudo-DMA transfers.  You
- *          only really want to use this if you're having a problem with
- *          dropped characters during high speed communications, and even
- *          then, you're going to be better off twiddling with transfersize.
- *
  * The card is detected and initialized in one of several ways : 
  * 1.  Autoprobe (default) - since the board is memory mapped, 
  *     a BIOS signature is scanned for to locate the registers.
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2014-10-02 16:55:53.000000000 +1000
+++ linux/drivers/scsi/dtc.h	2014-10-02 16:56:00.000000000 +1000
@@ -7,22 +7,6 @@
  *      +1 (303) 440-4894
  *
  * DISTRIBUTION RELEASE 2. 
- *
- * For more information, please consult 
- *
- * 
- * 
- * and 
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
  */
 
 #ifndef DTC3280_H
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2014-10-02 16:55:53.000000000 +1000
+++ linux/drivers/scsi/g_NCR5380.h	2014-10-02 16:56:00.000000000 +1000
@@ -11,18 +11,6 @@
  *    K.Lentin@cs.monash.edu.au
  *
  * ALPHA RELEASE 1. 
- *
- * For more information, please consult 
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
  */
 
 #ifndef GENERIC_NCR5380_H
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-10-02 16:55:58.000000000 +1000
+++ linux/drivers/scsi/mac_scsi.c	2014-10-02 16:56:00.000000000 +1000
@@ -11,18 +11,6 @@
  * Copyright 1995, Russell King
  *
  * ALPHA RELEASE 1.
- *
- * For more information, please consult
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
  */
 
 #include <linux/types.h>
Index: linux/drivers/scsi/mac_scsi.h
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.h	2014-10-02 16:55:50.000000000 +1000
+++ linux/drivers/scsi/mac_scsi.h	2014-10-02 16:56:00.000000000 +1000
@@ -8,18 +8,6 @@
  *      +1 (303) 440-4894
  *
  * ALPHA RELEASE 1.
- *
- * For more information, please consult
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
  */
 
 #ifndef MAC_NCR5380_H
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2014-10-02 16:55:53.000000000 +1000
+++ linux/drivers/scsi/pas16.h	2014-10-02 16:56:00.000000000 +1000
@@ -18,18 +18,6 @@
  * Media Vision
  * (510) 770-8600
  * (800) 348-7116
- * 
- * and 
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
  */
 
 
Index: linux/drivers/scsi/sun3_scsi.h
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.h	2014-10-02 16:55:53.000000000 +1000
+++ linux/drivers/scsi/sun3_scsi.h	2014-10-02 16:56:00.000000000 +1000
@@ -15,18 +15,6 @@
  *      +1 (303) 440-4894
  *
  * ALPHA RELEASE 1.
- *
- * For more information, please consult
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
  */
 
 #ifndef SUN3_SCSI_H
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2014-10-02 16:55:53.000000000 +1000
+++ linux/drivers/scsi/t128.h	2014-10-02 16:56:00.000000000 +1000
@@ -20,18 +20,6 @@
  * 5415 Randall Place
  * Fremont, CA 94538
  * 1+ (415) 770-1400, FAX 1+ (415) 770-9910
- *
- * and
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
  */
 
 #ifndef T128_H


