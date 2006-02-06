From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 6020] New: Intel Corporation 80960RP [i960RP
 Microprocessor] (rev 03) not detected
Date: Mon, 6 Feb 2006 11:33:08 -0800
Message-ID: <20060206113308.2e44a687.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:43965 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932313AbWBFTde (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 14:33:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neela.Kolli@engenio.com



Begin forwarded message:

Date: Mon, 6 Feb 2006 04:38:03 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 6020] New: Intel Corporation 80960RP [i960RP Microprocessor] (rev 03) not detected


http://bugzilla.kernel.org/show_bug.cgi?id=6020

           Summary: Intel Corporation 80960RP [i960RP Microprocessor] (rev
                    03) not detected
    Kernel Version: 2.6.15.2
            Status: NEW
          Severity: normal
             Owner: andmike@us.ibm.com
         Submitter: hadmut@danisch.de


Most recent kernel where this bug did not occur:
Distribution: Debian
Hardware Environment: HP Netserver LH3
Software Environment:
Problem Description:

Hi,

I have an ooold HP Netserver LH3 with this raid controller:
Intel Corporation 80960RP [i960RP Microprocessor] (rev 03)
0000:00:07.1 0100: 8086:1960 (rev 03)
        Subsystem: 103c:10c7


It was working well with the megaraid driver of kernel 2.4.26. 
But now I wanted to bring the machine to a recent 2.6 kernel. 
I have set

CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_SAS=y

At boottime the megaraid driver reports its existence, but in contrast to the
2.4 kernel, it doesn't say that it had detected disks. And then the kernel stops
with panic, claiming that it can't find its root device (/dev/sda1)

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
