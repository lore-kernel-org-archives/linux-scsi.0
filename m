From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10370] New: mount failed on ubuntu-8.04_ppc
Date: Mon, 31 Mar 2008 06:04:45 -0700 (PDT)
Message-ID: <bug-10370-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754694AbYCaNFQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2008 09:05:16 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2VD4jEj029639
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2008 06:04:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10370

           Summary: mount failed on ubuntu-8.04_ppc
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.24-12
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: GDT SCSI
        AssignedTo: scsi_drivers-gdt-scsi@kernel-bugs.osdl.org
        ReportedBy: pbarnabe@gmail.com


Latest working kernel version: 2.6.20-16
Earliest failing kernel version: 2.6.24-12
Distribution: Ubuntu-8.04_ppc
Hardware Environment: ibook G4
Software Environment:
Problem Description: when I tasted to mount a audio cdrom, mount failed, only
for audio cdrom; other cdrom works correttly.

Steps to reproduce: 

pietro@trip:~$ mount /media/cdrom0
mount: block device /dev/hdc is write-protected, mounting read-only
mount: wrong fs type, bad option, bad superblock on /dev/hdc,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

pietro@trip:~$ dmesg | tail
[ 1388.428934] ide: failed opcode was: unknown
[ 1388.429343] hdc: error code: 0x70  sense_key: 0x05  asc: 0x64  ascq: 0x00
[ 1388.429350] end_request: I/O error, dev hdc, sector 1024
[ 1388.429378] UDF-fs: No partition found (1)
[ 1388.625844] hdc: command error: status=0x51 { DriveReady SeekComplete Error
}
[ 1388.625857] hdc: command error: error=0x54 { AbortedCommand
LastFailedSense=0x05 }
[ 1388.625862] ide: failed opcode was: unknown
[ 1388.626273] hdc: error code: 0x70  sense_key: 0x05  asc: 0x64  ascq: 0x00
[ 1388.626281] end_request: I/O error, dev hdc, sector 64
[ 1388.626308] isofs_fill_super: bread failed, dev=hdc, iso_blknum=16, block=16


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
