From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [TRIVIAL 2.6] drivers_scsi_pcmcia_nsp_cs.c: kill
	duplicate #include
Date: Thu, 20 May 2004 17:08:03 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085036465.24931.149.camel@bach>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:3725 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S265023AbUETHIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 03:08:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi@vger.kernel.org, axboe@suse.de

 From:  a.othieno@bluewin.ch (Arthur Othieno)

---
  Hi,
  
  >From scripts/checkincludes.pl:
  
    ./drivers/scsi/pcmcia/nsp_cs.c: linux/module.h is included more than once.
 

--- trivial-2.6.6-bk6/drivers/scsi/pcmcia/nsp_cs.c.orig	2004-05-20 15:59:34.000000000 +1000
+++ trivial-2.6.6-bk6/drivers/scsi/pcmcia/nsp_cs.c	2004-05-20 15:59:34.000000000 +1000
@@ -38,7 +38,6 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/module.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
 #include <linux/stat.h>
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: a.othieno@bluewin.ch (Arthur Othieno): [TRIVIAL 2.6] drivers_scsi_pcmcia_nsp_cs.c: kill duplicate #include

