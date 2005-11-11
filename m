From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5566] New: scsi_eh_x/scsi_wq_x "zombie"
 processes in kernel 2.6.13+
Date: Fri, 11 Nov 2005 02:06:19 -0800
Message-ID: <20051111020619.5a73ad37.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:21961 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751246AbVKKKGh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 05:06:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>



Begin forwarded message:

Date: Mon, 7 Nov 2005 14:49:17 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5566] New: scsi_eh_x/scsi_wq_x "zombie" processes in kernel 2.6.13+


http://bugzilla.kernel.org/show_bug.cgi?id=5566

           Summary: scsi_eh_x/scsi_wq_x "zombie" processes in kernel 2.6.13+
    Kernel Version: 2.6.13+
            Status: NEW
          Severity: normal
             Owner: andrew.vasquez@qlogic.com
         Submitter: gator@cs.tu-berlin.de


Most recent kernel where this bug did not occur: 2.6.12
Starting around kernel version 2.6.13, the scsi_eh_x and scsi_wq_x
processes that are created per scsi host will not terminate if the
driver for the scsi interface is removed. I don't know whether there
are any serious problems involved with this, but one thing that is
definitely annoying, is that the process list fills very quickly when
modules are loaded/unloaded on demand, because 2 new processes will
be created every time the driver for a scsi adapter gets loaded.

(I guess, this happens with all scsi host modules - in my case, the
"culprit" is a qlogic fibre channel driver that gets loaded only when
needed.)

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
