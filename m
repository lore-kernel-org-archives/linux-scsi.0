From: Ballabio_Dario@emc.com
Subject: RE: [TRIVIAL] [2.5 patch] remove unneeded #define LinuxVersionCod
	e from eata.c (fwd)
Date: Mon, 26 May 2003 03:42:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <70652A801D9E0C469C28A0F8BCF49CF901B9236F@itmi1mx2.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxic2.corp.emc.com ([128.221.31.40]:40967 "EHLO
	mxic2.corp.emc.com") by vger.kernel.org with ESMTP id S264325AbTEZHlg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 May 2003 03:41:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: rusty@rustcorp.com.au
Cc: linux-scsi@vger.kernel.org

Your patch  is included in the next revision of the driver,  it will
be integrated after the irq diffs are in 2.5.70.
Pls. do not bother Linus with this stuff.
Cheers,

*****************************************
Ph.D. Dario Ballabio
EMC Computer Systems Italia spa
Lead Regional Specialist Europe South
NAS Tech Support
Mobile phone +393487978851
Office phone +390244571315
Cork extension: 5463

-----Original Message-----
From: Rusty Trivial Russell [mailto:rusty@rustcorp.com.au]
Sent: Monday, May 26, 2003 8:30 AM
To: Linus Torvalds
Cc: Dario Ballabio; linux-scsi@vger.kernel.org
Subject: [TRIVIAL] [2.5 patch] remove unneeded #define LinuxVersionCode
from eata.c (fwd)


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
  

--- trivial-2.5.69-bk18/drivers/scsi/eata.c.orig	2003-05-26
16:17:22.000000000 +1000
+++ trivial-2.5.69-bk18/drivers/scsi/eata.c	2003-05-26
16:17:22.000000000 +1000
@@ -449,10 +449,6 @@
 
 #include <linux/version.h>
 
-#ifndef LinuxVersionCode
-#define LinuxVersionCode(v, p, s) (((v)<<16)+((p)<<8)+(s))
-#endif
-
 #define MAX_INT_PARAM 10
 
 #if defined(MODULE)
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: Adrian Bunk <bunk@fs.tum.de>: [2.5 patch] remove unneeded #define
LinuxVersionCode from eata.c (fwd)
