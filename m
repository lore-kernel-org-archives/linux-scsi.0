From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [TRIVIAL 2.6] drivers_scsi_mvme147.c: kill duplicate
	#include
Date: Thu, 20 May 2004 17:08:00 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085035551.24929.141.camel@bach>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:65164 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S265022AbUETHIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 03:08:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, axboe@suse.de

 From:  a.othieno@bluewin.ch (Arthur Othieno)

---
  Hi,
  
  >From scripts/checkincludes.pl:
  
    ./drivers/scsi/mvme147.c: mvme147.h is included more than once.
  
  Output from `grep' shows:
  
    $ grep -n 'mvme147.h' drivers/scsi/mvme147.c
    16:#include "mvme147.h"
    125:#include "mvme147.h"
  
  Against 2.6.5. Thanks.
  
  

--- trivial-2.6.6-bk6/drivers/scsi/mvme147.c.orig	2004-05-20 15:59:33.000000000 +1000
+++ trivial-2.6.6-bk6/drivers/scsi/mvme147.c	2004-05-20 15:59:33.000000000 +1000
@@ -122,8 +122,6 @@
 
 #define HOSTS_C
 
-#include "mvme147.h"
-
 static Scsi_Host_Template driver_template = {
 	.proc_name		= "MVME147",
 	.name			= "MVME147 built-in SCSI",
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: a.othieno@bluewin.ch (Arthur Othieno): [TRIVIAL 2.6] drivers_scsi_mvme147.c: kill duplicate #include

