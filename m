From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4201] New: megaraid crashes at random with
 CERC ATA100/4ch (DELL Controller) on PowerEdge 600SC
Date: Fri, 11 Feb 2005 16:28:43 -0800
Message-ID: <20050211162843.398027e6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fw.osdl.org ([65.172.181.6]:46053 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262316AbVBLAXf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 19:23:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Steven_Nash@compuserve.com



Begin forwarded message:

Date: Fri, 11 Feb 2005 16:08:26 -0800
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4201] New: megaraid crashes at random with CERC ATA100/4ch (DELL Controller) on PowerEdge 600SC


http://bugme.osdl.org/show_bug.cgi?id=4201

           Summary: megaraid crashes at random with CERC  ATA100/4ch (DELL
                    Controller) on PowerEdge 600SC
    Kernel Version: 2.6.10
            Status: NEW
          Severity: high
             Owner: andmike@us.ibm.com
         Submitter: Steven_Nash@compuserve.com


Distribution: Fedora Core 3
Hardware Environment: x86 (32 bit)
Software Environment: Vanilla Kernel & Fedora Build Kernel
Problem Description: After a day or two (varies) the system hangs and the only
option is to hit the reset button.  Sometimes sda errors appear on the current
active VT but nothing appears in the logs after reboot (which is due to the
megaraid driver crashing.  I have tried forcing the old megaraid driver in the
kernel config and rebuilding but this has no effect.

Steps to reproduce:
Run a system for a few days, crashes seem to occure around 3 am approx.  The
only other SCSI device on the system is a Dell DLT Drive.

This is a serious bug!

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
