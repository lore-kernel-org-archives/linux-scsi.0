From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 2147] New: my scsi emulated cdrom is locked
Date: Thu, 19 Feb 2004 12:24:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040219122414.73fd7c6c.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:32946 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267546AbUBSUYH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 15:24:07 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>


Did ide-scsi break again?


Begin forwarded message:

Date: Thu, 19 Feb 2004 07:49:51 -0800
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 2147] New: my scsi emulated cdrom is locked


http://bugme.osdl.org/show_bug.cgi?id=2147

           Summary: my scsi emulated cdrom is locked
    Kernel Version: 2.6.3 (final)
            Status: NEW
          Severity: high
             Owner: io_other@kernel-bugs.osdl.org
         Submitter: cerebro84@vodafone.it


Distribution: Mandrake 9.2 
Hardware Environment: HL-DT-STDVD-ROM GDR8160B 
Software Environment: KDE 3.2, K3B 
Problem Description: I changed from kernel 2.6.2rc3 to 2.6.3final and I had 
this problem: my cdrom reader stopped to work. Everytime I try to access it my 
system freezes; I had to disable scsi emulation in order to let it work. 
 
Steps to reproduce: Ehm, buy an HL-DT-STDVD-ROM GDR8160B, enable scsi emulation 
and try to mount it!

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
