From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [2.5 patch] remove unneeded #define LinuxVersionCode from eata.c (fwd)
Date: Fri, 18 Apr 2003 17:45:38 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030418080205.C54272C309@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:41183 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S262933AbTDRHuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2003 03:50:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Dario Ballabio <ballabio_dario@emc.com>, linux-scsi@vger.kernel.org

From:  Adrian Bunk <bunk@fs.tum.de>

  Hi Linus,
  
  the trivial patch in the mail below still applies against and compiles 
  under 2.5.63.
  
  Please apply
  Adrian
  
  
  ----- Forwarded message from Adrian Bunk <bunk@fs.tum.de> -----
  
  Date: Sun, 12 Jan 2003 09:42:53 +0100
  From: Adrian Bunk <bunk@fs.tum.de>
  To: ballabio_dario@emc.com
  Subject: [2.5 patch] remove unneeded #define LinuxVersionCode from eata.c
  
  Hi Dario,
  
  the patch below removes the unneeded #define LinuxVersionCode from 
  eata.c. It's not used and if it was needed KERNEL_VERSION in 
  include/linux/version.h does the same.
  
  I've tested the compilation with 2.5.56.
  
  Please apply
  Adrian
  

--- trivial-2.5.67-bk8/drivers/scsi/eata.c.orig	2003-04-18 17:43:44.000000000 +1000
+++ trivial-2.5.67-bk8/drivers/scsi/eata.c	2003-04-18 17:43:44.000000000 +1000
@@ -449,10 +449,6 @@
 
 #include <linux/version.h>
 
-#ifndef LinuxVersionCode
-#define LinuxVersionCode(v, p, s) (((v)<<16)+((p)<<8)+(s))
-#endif
-
 #define MAX_INT_PARAM 10
 
 #if defined(MODULE)
-- 
  Don't blame me: the Monkey is driving
  File: Adrian Bunk <bunk@fs.tum.de>: [2.5 patch] remove unneeded #define LinuxVersionCode from eata.c (fwd)
