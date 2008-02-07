From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9909] New: Unable to handle kernel NULL pointer dereference at 0000000000000010 (mptsas_probe_expander_phys+0x62/0x427)
Date: Thu,  7 Feb 2008 05:52:14 -0800 (PST)
Message-ID: <bug-9909-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbYBGNwS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 08:52:18 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m17DqEGw016205
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2008 05:52:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9909

           Summary: Unable to handle kernel NULL pointer dereference at
                    0000000000000010 (mptsas_probe_expander_phys+0x62/0x427)
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.23 - 2.6.23.14
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: olel@ans.pl


Latest working kernel version: 2.6.22-2.6.22.17
Distribution: Gentoo
Hardware Environment:
00:00.0 Host bridge [0600]: Intel Corporation 5000X Chipset Memory Controller
Hub [8086:25c0] (rev 12)
00:02.0 PCI bridge [0604]: Intel Corporation 5000 Series Chipset PCI Express x4
Port 2 [8086:25e2] (rev 12)
00:03.0 PCI bridge [0604]: Intel Corporation 5000 Series Chipset PCI Express x4
Port 3 [8086:25e3] (rev 12)
00:04.0 PCI bridge [0604]: Intel Corporation 5000 Series Chipset PCI Express x8
Port 4-5 [8086:25f8] (rev 12)
00:05.0 PCI bridge [0604]: Intel Corporation 5000 Series Chipset PCI Express x4
Port 5 [8086:25e5] (rev 12)
00:06.0 PCI bridge [0604]: Intel Corporation 5000 Series Chipset PCI Express x8
Port 6-7 [8086:25f9] (rev 12)
00:07.0 PCI bridge [0604]: Intel Corporation 5000 Series Chipset PCI Express x4
Port 7 [8086:25e7] (rev 12)
00:08.0 System peripheral [0880]: Intel Corporation 5000 Series Chipset DMA
Engine [8086:1a38] (rev 12)
00:10.0 Host bridge [0600]: Intel Corporation 5000 Series Chipset FSB Registers
[8086:25f0] (rev 12)
00:10.1 Host bridge [0600]: Intel Corporation 5000 Series Chipset FSB Registers
[8086:25f0] (rev 12)
00:10.2 Host bridge [0600]: Intel Corporation 5000 Series Chipset FSB Registers
[8086:25f0] (rev 12)
00:11.0 Host bridge [0600]: Intel Corporation 5000 Series Chipset Reserved
Registers [8086:25f1] (rev 12)
00:13.0 Host bridge [0600]: Intel Corporation 5000 Series Chipset Reserved
Registers [8086:25f3] (rev 12)
00:15.0 Host bridge [0600]: Intel Corporation 5000 Series Chipset FBD Registers
[8086:25f5] (rev 12)
00:16.0 Host bridge [0600]: Intel Corporation 5000 Series Chipset FBD Registers
[8086:25f6] (rev 12)
00:1c.0 PCI bridge [0604]: Intel Corporation 631xESB/632xESB/3100 Chipset PCI
Express Root Port 1 [8086:2690] (rev 09)
00:1d.0 USB Controller [0c03]: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #1 [8086:2688] (rev 09)
00:1d.1 USB Controller [0c03]: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #2 [8086:2689] (rev 09)
00:1d.7 USB Controller [0c03]: Intel Corporation 631xESB/632xESB/3100 Chipset
EHCI USB2 Controller [8086:268c] (rev 09)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev
d9)
00:1f.0 ISA bridge [0601]: Intel Corporation 631xESB/632xESB/3100 Chipset LPC
Interface Controller [8086:2670] (rev 09)
00:1f.1 IDE interface [0101]: Intel Corporation 631xESB/632xESB IDE Controller
[8086:269e] (rev 09)
00:1f.2 IDE interface [0101]: Intel Corporation 631xESB/632xESB/3100 Chipset
SATA IDE Controller [8086:2680] (rev 09)
01:00.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic SAS1068E
PCI-Express Fusion-MPT SAS [1000:0058] (rev 08)
02:00.0 PCI bridge [0604]: Broadcom EPB PCI-Express to PCI-X Bridge [1166:0103]
(rev c3)
03:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme II BCM5708
Gigabit Ethernet [14e4:164c] (rev 12)
04:00.0 PCI bridge [0604]: Intel Corporation 6311ESB/6321ESB PCI Express
Upstream Port [8086:3500] (rev 01)
04:00.3 PCI bridge [0604]: Intel Corporation 6311ESB/6321ESB PCI Express to
PCI-X Bridge [8086:350c] (rev 01)
05:00.0 PCI bridge [0604]: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E1 [8086:3510] (rev 01)
05:01.0 PCI bridge [0604]: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E2 [8086:3514] (rev 01)
06:00.0 PCI bridge [0604]: Broadcom EPB PCI-Express to PCI-X Bridge [1166:0103]
(rev c3)
07:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme II BCM5708
Gigabit Ethernet [14e4:164c] (rev 12)
0e:0d.0 VGA compatible controller [0300]: ATI Technologies Inc ES1000
[1002:515e] (rev 02)

Software Environment:
Gnu C                  4.1.2
Gnu make               3.81
binutils               Binutils
util-linux             2.12r
mount                  2.12r
module-init-tools      3.4
e2fsprogs              1.40.5
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.9

Attaching dmesg with oopses (2.6.23 and 2.6.23.14) and dmesg from 2.6.14.17
(working kernel). Please also note that 2.6.23.14 is not able to dump a full
Oops msg!


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
