From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196707] New: Adaptec ICP9087MA: aacraid prints "AAC: Host
 adapter is dead (or got a PCI error) -1" twice times around errors of aacraid
 and the kernel crashes after starting the "Kernel Device Manager"
Date: Fri, 18 Aug 2017 20:42:13 +0000
Message-ID: <bug-196707-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34806 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751126AbdHRUmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Aug 2017 16:42:18 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5F82628C37
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2017 20:42:18 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=196707

            Bug ID: 196707
           Summary: Adaptec ICP9087MA: aacraid prints "AAC: Host adapter
                    is dead (or got a PCI error) -1" twice times around
                    errors of aacraid and the kernel crashes after
                    starting the "Kernel Device Manager"
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.12.8
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: kernel.org@yaze-ag.de
                CC: a@borouhin.com, arekm@maven.pl, bugzie@grubelek.pl,
                    chrismac@niksun.com, davygrvy@pobox.com,
                    harold@snel.ws, he001@fitmsg.net, hm10439@gmail.com,
                    rodrigoaguileraparraga@gmail.com,
                    scnaifeh@hotmail.com,
                    scsi_drivers-aacraid@kernel-bugs.osdl.org
        Regression: No

Created attachment 258013
  --> https://bugzilla.kernel.org/attachment.cgi?id=258013&action=edit
Kernel output of 3 kernel starts with connected / disconnected HDDs and
different kernels

+++ This bug was initially created as a clone of Bug #151661 +++

Hi,

my english language is not so good. I hope you understand what I write here.

The kernel 4.12.8 crashes after errors from aacraid and after the start of the
"kernel device manager" when I connect 8 HDDs (power on) to the
ICP9087MA-RAID-Controller. (See attachment 0_...)

The crash is before the Kernel opens log files in /var/log. I found NO entries
in the log files. So I configure grub (in /etc/default/grub) and the kernel to
use the serial line (/dev/ttyS0, COM1) as the console. On my Notebook I capture
the serial output of the starting kernel with minicom.

If I disconnect the 8 HDDs (power off) the kernel 4.12.8 starts normal and I
can use the system but without the two Host drives (2 x RAID-5) of the
ICP9087MA.
(See attachment 1_...)

When I use different kernels of version 3.x.x (from kernel.org or Debian) all
works fine when the 8 HDDs are connected to the ICP9087MA-Raid-Controller. (See
attachment 2_...)

Attachment (output of 3 Kernel starts in one attachment):

0_kernel_crash_(4.12.8)_with_all_drives_at_the_ICP9087MA.cap
1_normal_start_(4.12.8)_without_any_drive_at_the_ICP9087MA.cap
2_normal_start_(3.18.65)_with_all_drives_at_the_ICP9087MA.cap

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
You are watching someone on the CC list of the bug.
