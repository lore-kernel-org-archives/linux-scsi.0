From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bug 3244] New: megaraid_mbox.c broken: unimplemented parts
Date: Thu, 19 Aug 2004 09:21:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040819092147.1437bd71.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:45449 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266657AbUHSQX1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 12:23:27 -0400
Received: from bix (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id i7JGNO123568
	for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 09:23:24 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Thu, 19 Aug 2004 05:11:37 -0700
From: bugme-daemon@osdl.org
To: akpm@digeo.com
Subject: [Bug 3244] New: megaraid_mbox.c broken: unimplemented parts


http://bugme.osdl.org/show_bug.cgi?id=3244

           Summary: megaraid_mbox.c broken: unimplemented parts
    Kernel Version: 2.6.8.1-mm2
            Status: NEW
          Severity: high
             Owner: akpm@digeo.com
         Submitter: damir.perisa@bluewin.ch


Distribution: ArchLinux CURRENT 
(i'm the pkg maintainer of kernel26mm) 
 
Hardware Environment: P4 
 
Software Environment: gcc 3.4.1 
 
Problem Description:  
 
  LD      drivers/scsi/megaraid/built-in.o 
  CC [M]  drivers/scsi/megaraid/megaraid_mbox.o 
drivers/scsi/megaraid/megaraid_mbox.c: In function `megaraid_queue_command': 
drivers/scsi/megaraid/megaraid_mbox.c:112: sorry, unimplemented: inlining 
failed in call to 'megaraid_mbox_build_cmd': function body not available 
drivers/scsi/megaraid/megaraid_mbox.c:1455: sorry, unimplemented: called from 
here 
drivers/scsi/megaraid/megaraid_mbox.c:121: sorry, unimplemented: inlining 
failed in call to 'megaraid_mbox_runpendq': function body not available 
drivers/scsi/megaraid/megaraid_mbox.c:1458: sorry, unimplemented: called from 
here 
make[3]: *** [drivers/scsi/megaraid/megaraid_mbox.o] Error 1 
make[2]: *** [drivers/scsi/megaraid] Error 2 
make[1]: *** [drivers/scsi] Error 2 
make: *** [drivers] Error 2 
==> ERROR: Build Failed.  Aborting... 
 
Steps to reproduce: 
1) try to compile this as module 
2) watch it failing

------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
