From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] MPT Fusion driver update
Date: 07 Nov 2003 09:38:25 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068219506.1831.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:6148 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264418AbTKGPid (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 10:38:33 -0500
Received: from mulgrave-w.il.steeleye.com (il-ppp.sc.steeleye.com [172.17.6.240])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id hA7FcPY18860
	for <linux-scsi@vger.kernel.org>; Fri, 7 Nov 2003 10:38:25 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This one's from: Eric Moore <emoore@lsil.com>

Changes in patch
* removed __init from mptscsih_setup
* removed __init from get_setup_token
* changed copyright from 2002 to 2003
* added new mailto, and removed Pam.Delaney
* added some fix for 32bit emulation when unloading mptctl module

James

diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/isense.c linux-2.6.0-test9/drivers/message/fusion/isense.c
--- linux-2.6.0-test9-reference/drivers/message/fusion/isense.c	2003-10-25 12:43:38.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/isense.c	2003-11-04 10:00:16.208538968 -0700
@@ -5,11 +5,11 @@
  *      Error Report logging output.  This module implements SCSI-3
  *      Opcode lookup and a sorted table of SCSI-3 ASC/ASCQ strings.
  *
- *  Copyright (c) 1991-2002 Steven J. Ralston
+ *  Copyright (c) 1991-2003 Steven J. Ralston
  *  Written By: Steven J. Ralston
  *  (yes I wrote some of the orig. code back in 1991!)
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: isense.c,v 1.33 2002/02/27 18:44:19 sralston Exp $
  */
@@ -66,7 +66,7 @@
 #endif
 
 #define MODULEAUTHOR "Steven J. Ralston"
-#define COPYRIGHT "Copyright (c) 2001-2002 " MODULEAUTHOR
+#define COPYRIGHT "Copyright (c) 2001-2003 " MODULEAUTHOR
 #include "mptbase.h"
 
 #include "isense.h"
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptbase.c linux-2.6.0-test9/drivers/message/fusion/mptbase.c
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptbase.c	2003-10-25 12:43:08.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptbase.c	2003-11-04 10:00:16.207539120 -0700
@@ -44,10 +44,10 @@
  *      for gobs of hard work fixing and optimizing LAN code.
  *      THANK YOU!
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptbase.c,v 1.126 2002/12/16 15:28:45 pdelaney Exp $
  */
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptbase.h linux-2.6.0-test9/drivers/message/fusion/mptbase.h
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptbase.h	2003-10-25 12:43:02.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptbase.h	2003-11-04 10:00:16.206539272 -0700
@@ -8,10 +8,10 @@
  *  Credits:
  *     (see mptbase.c)
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptbase.h,v 1.144 2003/01/28 21:31:56 pdelaney Exp $
  */
@@ -77,11 +77,11 @@
 #endif
 
 #ifndef COPYRIGHT
-#define COPYRIGHT	"Copyright (c) 1999-2002 " MODULEAUTHOR
+#define COPYRIGHT	"Copyright (c) 1999-2003 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"2.05.00.03"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.00.03"
+#define MPT_LINUX_VERSION_COMMON	"2.05.00.04"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.00.04"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptctl.c linux-2.6.0-test9/drivers/message/fusion/mptctl.c
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptctl.c	2003-10-25 12:42:49.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptctl.c	2003-11-04 10:00:15.941579552 -0700
@@ -29,10 +29,10 @@
  *
  *      (see also mptbase.c)
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Originally By: Steven J. Ralston, Noah Romer
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptctl.c,v 1.63 2002/12/03 21:26:33 pdelaney Exp $
  */
@@ -91,7 +91,7 @@
 #include "../../scsi/scsi.h"
 #include "../../scsi/hosts.h"
 
-#define COPYRIGHT	"Copyright (c) 1999-2001 LSI Logic Corporation"
+#define COPYRIGHT	"Copyright (c) 1999-2003 LSI Logic Corporation"
 #define MODULEAUTHOR	"Steven J. Ralston, Noah Romer, Pamela Delaney"
 #include "mptbase.h"
 #include "mptctl.h"
@@ -2985,6 +2985,21 @@
 	mpt_deregister(mptctl_id);
 	printk(KERN_INFO MYNAM ": Deregistered from Fusion MPT base driver\n");
 
+#ifdef CONFIG_COMPAT
+	unregister_ioctl32_conversion(MPTIOCINFO);
+	unregister_ioctl32_conversion(MPTIOCINFO1);
+	unregister_ioctl32_conversion(MPTTARGETINFO);
+	unregister_ioctl32_conversion(MPTTEST);
+	unregister_ioctl32_conversion(MPTEVENTQUERY);
+	unregister_ioctl32_conversion(MPTEVENTENABLE);
+	unregister_ioctl32_conversion(MPTEVENTREPORT);
+	unregister_ioctl32_conversion(MPTHARDRESET);
+	unregister_ioctl32_conversion(MPTCOMMAND32);
+	unregister_ioctl32_conversion(MPTFWDOWNLOAD32);
+	unregister_ioctl32_conversion(HP_GETHOSTINFO);
+	unregister_ioctl32_conversion(HP_GETTARGETINFO);
+#endif
+
 	/* Free allocated memory */
 	for (i=0; i<MPT_MAX_ADAPTERS; i++) {
 		ioc = NULL;
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptctl.h linux-2.6.0-test9/drivers/message/fusion/mptctl.h
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptctl.h	2003-10-25 12:43:38.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptctl.h	2003-11-04 10:00:16.209538816 -0700
@@ -15,10 +15,10 @@
  *
  *      (see also mptbase.c)
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptctl.h,v 1.13 2002/12/03 21:26:33 pdelaney Exp $
  */
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptlan.c linux-2.6.0-test9/drivers/message/fusion/mptlan.c
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptlan.c	2003-10-25 12:43:39.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptlan.c	2003-11-04 10:00:16.209538816 -0700
@@ -23,8 +23,9 @@
  *
  *      (see also mptbase.c)
  *
- *  Copyright (c) 2000-2002 LSI Logic Corporation
+ *  Copyright (c) 2000-2003 LSI Logic Corporation
  *  Originally By: Noah Romer
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptlan.c,v 1.53 2002/10/17 20:15:58 pdelaney Exp $
  */
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptscsih.c linux-2.6.0-test9/drivers/message/fusion/mptscsih.c
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptscsih.c	2003-10-25 12:43:27.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptscsih.c	2003-11-04 10:00:16.208538968 -0700
@@ -21,10 +21,10 @@
  *
  *      (see mptbase.c)
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Original author: Steven J. Ralston
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptscsih.c,v 1.104 2002/12/03 21:26:34 pdelaney Exp $
  */
@@ -6900,7 +6900,7 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static int
-__init get_setup_token(char *p)
+get_setup_token(char *p)
 {
 	char *cur = setup_token;
 	char *pc;
@@ -6918,7 +6918,7 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static int
-__init mptscsih_setup(char *str)
+mptscsih_setup(char *str)
 {
 	char *cur = str;
 	char *pc, *pv;
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/mptscsih.h linux-2.6.0-test9/drivers/message/fusion/mptscsih.h
--- linux-2.6.0-test9-reference/drivers/message/fusion/mptscsih.h	2003-10-25 12:44:58.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/mptscsih.h	2003-11-04 10:00:16.210538664 -0700
@@ -15,10 +15,10 @@
  *
  *      (see also mptbase.c)
  *
- *  Copyright (c) 1999-2002 LSI Logic Corporation
+ *  Copyright (c) 1999-2003 LSI Logic Corporation
  *  Originally By: Steven J. Ralston
  *  (mailto:netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: mptscsih.h,v 1.21 2002/12/03 21:26:35 pdelaney Exp $
  */
diff -uarN linux-2.6.0-test9-reference/drivers/message/fusion/scsi3.h linux-2.6.0-test9/drivers/message/fusion/scsi3.h
--- linux-2.6.0-test9-reference/drivers/message/fusion/scsi3.h	2003-10-25 12:43:30.000000000 -0600
+++ linux-2.6.0-test9/drivers/message/fusion/scsi3.h	2003-11-04 10:00:16.208538968 -0700
@@ -4,10 +4,10 @@
  *      (Ultimately) SCSI-3 definitions; for now, inheriting
  *      SCSI-2 definitions.
  *
- *  Copyright (c) 1996-2002 Steven J. Ralston
+ *  Copyright (c) 1996-2003 Steven J. Ralston
  *  Written By: Steven J. Ralston (19960517)
  *  (mailto:sjralston1@netscape.net)
- *  (mailto:Pam.Delaney@lsil.com)
+ *  (mailto:mpt_linux_developer@lsil.com)
  *
  *  $Id: scsi3.h,v 1.9 2002/02/27 18:45:02 sralston Exp $
  */

