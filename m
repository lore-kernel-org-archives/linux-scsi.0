From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4473] New: QLogic 2100: SCSI timeouts, device
 resets, and crashes kernel
Date: Mon, 11 Apr 2005 13:51:32 -0700
Message-ID: <20050411135132.13b258dd.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:41905 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261930AbVDKUvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 16:51:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gregsurbey@hotmail.com



Begin forwarded message:

Date: Mon, 11 Apr 2005 13:03:16 -0700
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4473] New: QLogic 2100: SCSI timeouts, device resets, and crashes kernel


http://bugme.osdl.org/show_bug.cgi?id=4473

           Summary: QLogic 2100: SCSI timeouts, device resets, and crashes
                    kernel
    Kernel Version: 2.6.10 2.6.11.6.6 2.6.11-gentoo-r5
            Status: NEW
          Severity: blocking
             Owner: andmike@us.ibm.com
         Submitter: gregsurbey@hotmail.com


Distribution: Gentoo 2005.0
Hardware Environment: Dell PowerEdge 600SC
Configuration: md RAID-5 11 disks 1 spare 

Card Description:
QLogic PCI to Fibre Channel Host Adapter for QLA2100:
        Firmware version 1.19.24 TP, Driver version 8.00.02b4-k
ISP: ISP2100, Serial# A61828
Request Queue = 0x1fce8000, Response Queue = 0x1fce2000
Request Queue count = 128, Response Queue count = 64
Total number of active commands = 0
Total number of interrupts = 77339
    Device queue depth = 0x10
Number of free request entries = 59
Number of mailbox timeouts = 0
Number of ISP aborts = 0
Number of loop resyncs = 0
Number of retries for empty slots = 0
Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
Host adapter:loop state = <READY>, flags = 0x1c93
Dpc flags = 0x80000
MBX flags = 0x0
Link down Timeout = 000
Port down retry = 030
Login retry count = 030
Commands retried with dropped frame(s) = 0
Product ID = 4953 5020 2020 0001

During the heavy use of md RAID reconstruction the card creates output in dmesg
which I will attach to this bug report in my next post. 

Steps to reproduce:
Use a Qlogic 2100 card with the qla2xxx driver

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
