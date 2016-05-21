From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118621] New: After upgrading from ubuntu 15.10 to 16.04 CD-R's
 won't mount, others mount just fine
Date: Sat, 21 May 2016 11:26:30 +0000
Message-ID: <bug-118621-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52125 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbcEUL0f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2016 07:26:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BAAB720381
	for <linux-scsi@vger.kernel.org>; Sat, 21 May 2016 11:26:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2152B2038A
	for <linux-scsi@vger.kernel.org>; Sat, 21 May 2016 11:26:31 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=118621

            Bug ID: 118621
           Summary: After upgrading from ubuntu 15.10 to 16.04 CD-R's
                    won't mount, others mount just fine
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.4.0-22-generic
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: karl.lindheimer@gmail.com
        Regression: No

After upgrading ubuntu 15.10 AMD64 to ubuntu ubuntu 16.04 I had to boot the
last kernel 4.4.0-22 because the latest one fails to boot with my Radeon
graphics card.  However this problem exists on the i686 ubuntu 16.04 with the
latest kernel on my intel Macbook as well.  The problem is that CD-R disks are
not recognized, nor mounted.  The disks are fine, and work on boot, but will
not mount on the desktop.  DVD-R, audio, DVD movies all mount fine.  It is only
specific to ubuntu 16.04 with CD-R disks, and seems to effect all of the
kernels.

Here is the output of several commands:

Dmesg:

[11778.815534] scsi_io_completion: 44 callbacks suppressed
[11778.815548] sr 4:0:0:0: [sr0] tag#28 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[11778.815555] sr 4:0:0:0: [sr0] tag#28 Sense Key : Illegal Request [current] 
[11778.815564] sr 4:0:0:0: [sr0] tag#28 Add. Sense: Illegal mode for this track
[11778.815570] sr 4:0:0:0: [sr0] tag#28 CDB: Read(10) 28 00 00 01 62 b8 00 00
02 00
[11778.815574] blk_update_request: 44 callbacks suppressed
[11778.815577] blk_update_request: I/O error, dev sr0, sector 363232
[11778.875542] sr 4:0:0:0: [sr0] tag#29 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[11778.875553] sr 4:0:0:0: [sr0] tag#29 Sense Key : Illegal Request [current] 
[11778.875562] sr 4:0:0:0: [sr0] tag#29 Add. Sense: Illegal mode for this track
[11778.875568] sr 4:0:0:0: [sr0] tag#29 CDB: Read(10) 28 00 00 01 62 b8 00 00
02 00
[11778.875573] blk_update_request: I/O error, dev sr0, sector 363232
[11778.875579] buffer_io_error: 44 callbacks suppressed
[11778.875583] Buffer I/O error on dev sr0, logical block 45404, async page
read
[11830.277824] sr 4:0:0:0: [sr0] tag#25 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[11830.277831] sr 4:0:0:0: [sr0] tag#25 Sense Key : Illegal Request [current] 
[11830.277837] sr 4:0:0:0: [sr0] tag#25 Add. Sense: Illegal mode for this track
[11830.277841] sr 4:0:0:0: [sr0] tag#25 CDB: Read(10) 28 00 00 04 b2 22 00 00
02 00
[11830.277844] blk_update_request: I/O error, dev sr0, sector 1230984
[11830.285408] sr 4:0:0:0: [sr0] tag#26 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[11830.285418] sr 4:0:0:0: [sr0] tag#26 Sense Key : Illegal Request [current] 
[11830.285428] sr 4:0:0:0: [sr0] tag#26 Add. Sense: Illegal mode for this track
[11830.285434] sr 4:0:0:0: [sr0] tag#26 CDB: Read(10) 28 00 00 04 b2 22 00 00
01 00
[11830.285439] blk_update_request: I/O error, dev sr0, sector 1230984
[11830.285447] Buffer I/O error on dev sr0, logical block 307746, async page
read
[11830.293600] sr 4:0:0:0: [sr0] tag#28 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[11830.293610] sr 4:0:0:0: [sr0] tag#28 Sense Key : Illegal Request [current] 
[11830.293619] sr 4:0:0:0: [sr0] tag#28 Add. Sense: Illegal mode for this track
[11830.293626] sr 4:0:0:0: [sr0] tag#28 CDB: Read(10) 28 00 00 04 b2 23 00 00
01 00
[11830.293630] blk_update_request: I/O error, dev sr0, sector 1230988
[11830.293637] Buffer I/O error on dev sr0, logical block 307747, async page
read
[11949.648596] ISO 9660 Extensions: Microsoft Joliet Level 3
[11949.710957] ISO 9660 Extensions: RRIP_1991A
[12017.588415] sr 4:0:0:0: [sr0] tag#21 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[12017.588426] sr 4:0:0:0: [sr0] tag#21 Sense Key : Illegal Request [current] 
[12017.588434] sr 4:0:0:0: [sr0] tag#21 Add. Sense: Illegal mode for this track
[12017.588442] sr 4:0:0:0: [sr0] tag#21 CDB: Read(10) 28 00 00 03 6b aa 00 00
02 00
[12017.588447] blk_update_request: I/O error, dev sr0, sector 896680
[12017.600417] sr 4:0:0:0: [sr0] tag#23 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[12017.600428] sr 4:0:0:0: [sr0] tag#23 Sense Key : Illegal Request [current] 
[12017.600437] sr 4:0:0:0: [sr0] tag#23 Add. Sense: Illegal mode for this track
[12017.600444] sr 4:0:0:0: [sr0] tag#23 CDB: Read(10) 28 00 00 03 6b ab 00 00
01 00
[12017.600448] blk_update_request: I/O error, dev sr0, sector 896684
[12017.600455] Buffer I/O error on dev sr0, logical block 224171, async page
read
karl@DX4380G:~$ 

And lshw:

karl@DX4380G:~$ sudo lshw -C disk
[sudo] password for karl: 
  *-disk                  
       description: ATA Disk
       product: ST1000DM003-9YN1
       vendor: Seagate
       physical id: 0.0.0
       bus info: scsi@0:0.0.0
       logical name: /dev/sda
       version: CC4B
       serial: S1D44PJY
       size: 931GiB (1TB)
       capabilities: gpt-1.00 partitioned partitioned:gpt
       configuration: ansiversion=5 guid=7d587593-555e-4e7d-9040-7666ef407fde
logicalsectorsize=512 sectorsize=4096
  *-cdrom
       description: DVD-RAM writer
       product: DVDRAM GH82N
       vendor: HL-DT-ST
       physical id: 0.0.0
       bus info: scsi@4:0.0.0
       logical name: /dev/cdrom
       logical name: /dev/cdrw
       logical name: /dev/dvd
       logical name: /dev/dvdrw
       logical name: /dev/sr0
       version: 1.00
       capabilities: removable audio cd-r cd-rw dvd dvd-r dvd-ram
       configuration: ansiversion=5 status=ready
     *-medium
          physical id: 0
          logical name: /dev/cdrom
karl@DX4380G:~$

-- 
You are receiving this mail because:
You are the assignee for the bug.
