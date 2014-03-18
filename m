From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 03/12] scsi/NCR5380: remove old CVS keywords
Date: Tue, 18 Mar 2014 11:42:15 +1100
Message-ID: <20140318004213.512954385@telegraphics.com.au>
References: <20140318004212.612472697@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-cvs-keywords
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c   |    2 --
 drivers/scsi/NCR5380.h   |    4 ----
 drivers/scsi/g_NCR5380.c |    4 ----
 drivers/scsi/g_NCR5380.h |    4 ----
 drivers/scsi/mac_scsi.c  |    4 ----
 drivers/scsi/mac_scsi.h  |    4 ----
 drivers/scsi/sun3_scsi.c |    4 ----
 drivers/scsi/sun3_scsi.h |    4 ----
 drivers/scsi/t128.c      |    4 ----
 drivers/scsi/t128.h      |    4 ----
 10 files changed, 38 deletions(-)

Index: linux-m68k/drivers/scsi/NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.c	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.c	2014-03-18 00:18:32.000000000 +1100
@@ -27,8 +27,6 @@
  */
 
 /*
- * $Log: NCR5380.c,v $
-
  * Revision 1.10 1998/9/2	Alan Cox
  *				(alan@lxorguk.ukuu.org.uk)
  * Fixed up the timer lockups reported so far. Things still suck. Looking 
Index: linux-m68k/drivers/scsi/NCR5380.h
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.h	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.h	2014-03-18 00:18:32.000000000 +1100
@@ -21,10 +21,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: NCR5380.h,v $
- */
-
 #ifndef NCR5380_H
 #define NCR5380_H
 
Index: linux-m68k/drivers/scsi/g_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/g_NCR5380.c	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/g_NCR5380.c	2014-03-18 00:18:32.000000000 +1100
@@ -78,10 +78,6 @@
  *     
  */
 
-/*
- * $Log: generic_NCR5380.c,v $
- */
-
 /* settings for DTC3181E card with only Mustek scanner attached */
 #define USLEEP
 #define USLEEP_POLL	1
Index: linux-m68k/drivers/scsi/g_NCR5380.h
===================================================================
--- linux-m68k.orig/drivers/scsi/g_NCR5380.h	2014-03-18 00:18:30.000000000 +1100
+++ linux-m68k/drivers/scsi/g_NCR5380.h	2014-03-18 00:18:32.000000000 +1100
@@ -25,10 +25,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: generic_NCR5380.h,v $
- */
-
 #ifndef GENERIC_NCR5380_H
 #define GENERIC_NCR5380_H
 
Index: linux-m68k/drivers/scsi/mac_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_scsi.c	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_scsi.c	2014-03-18 00:18:32.000000000 +1100
@@ -25,10 +25,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: mac_NCR5380.c,v $
- */
-
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/ctype.h>
Index: linux-m68k/drivers/scsi/mac_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_scsi.h	2014-03-18 00:18:30.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_scsi.h	2014-03-18 00:18:32.000000000 +1100
@@ -22,10 +22,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: cumana_NCR5380.h,v $
- */
-
 #ifndef MAC_NCR5380_H
 #define MAC_NCR5380_H
 
Index: linux-m68k/drivers/scsi/sun3_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.c	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.c	2014-03-18 00:18:32.000000000 +1100
@@ -45,10 +45,6 @@
  * USLEEP - enable support for devices that don't disconnect.  Untested.
  */
 
-/*
- * $Log: sun3_NCR5380.c,v $
- */
-
 #define AUTOSENSE
 
 #include <linux/types.h>
Index: linux-m68k/drivers/scsi/sun3_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:30.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:32.000000000 +1100
@@ -29,10 +29,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: cumana_NCR5380.h,v $
- */
-
 #ifndef SUN3_NCR5380_H
 #define SUN3_NCR5380_H
 
Index: linux-m68k/drivers/scsi/t128.c
===================================================================
--- linux-m68k.orig/drivers/scsi/t128.c	2014-03-17 23:49:28.000000000 +1100
+++ linux-m68k/drivers/scsi/t128.c	2014-03-18 00:18:32.000000000 +1100
@@ -102,10 +102,6 @@
  * 15 9-11
  */
  
-/*
- * $Log: t128.c,v $
- */
-
 #include <linux/signal.h>
 #include <linux/io.h>
 #include <linux/blkdev.h>
Index: linux-m68k/drivers/scsi/t128.h
===================================================================
--- linux-m68k.orig/drivers/scsi/t128.h	2014-03-18 00:18:30.000000000 +1100
+++ linux-m68k/drivers/scsi/t128.h	2014-03-18 00:18:32.000000000 +1100
@@ -34,10 +34,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * $Log: t128.h,v $
- */
-
 #ifndef T128_H
 #define T128_H
 
