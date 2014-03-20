From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 72541] New: CentOS 6.5 -- mpt2sas0: _base_fault_reset_work :
 SAS host is non-operational !!!!
Date: Thu, 20 Mar 2014 12:57:32 +0000
Message-ID: <bug-72541-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35697 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903AbaCTM5f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2014 08:57:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F0AF22024D
	for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2014 12:57:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E818A20240
	for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2014 12:57:32 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=72541

            Bug ID: 72541
           Summary: CentOS 6.5 -- mpt2sas0: _base_fault_reset_work : SAS
                    host is non-operational !!!!
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.32-431
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: oleg.khrustov@gmail.com
        Regression: No

Dell c5220

Controller information
------------------------------------------------------------------------
  Controller type                         : SAS2008
  BIOS version                            : 7.27.00.00
  Firmware version                        : 14.00.02.00
  Channel description                     : 1 Serial Attached SCSI

RAID1, 2xST9500620NS



Was running smoothly during 3 months machine finally stuck and/or rootfs
remounted to readonly.

Dmesg shows mpt2 sas errors.



mpt2sas0: _base_fault_reset_work : SAS host is non-operational !!!!
mpt2sas0: _base_fault_reset_work : SAS host is non-operational !!!!
mpt2sas0: _base_fault_reset_work : SAS host is non-operational !!!!
mpt2sas0: _base_fault_reset_work : SAS host is non-operational !!!!
mpt2sas0: _base_fault_reset_work : SAS host is non-operational !!!!
mpt2sas0: _base_fault_reset_work : SAS host is non-operational !!!!
mpt2sas0: _base_fault_reset_work: Running mpt2sas_dead_ioc thread success !!!!
mpt2sas0: IR shutdown (sending)
sd 0:1:0:0: [sda] Unhandled error code
sd 0:1:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 03 16 6a b8 00 00 18 00
sd 0:1:0:0: [sda] Unhandled error code
sd 0:1:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 03 d9 32 98 00 00 08 00
Buffer I/O error on device dm-0, logical block 7942227
lost page write due to I/O error on dm-0
JBD2: Detected IO errors while flushing file data on dm-0-8
Aborting journal on device dm-0-8.
sd 0:1:0:0: [sda] Unhandled error code
sd 0:1:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 03 13 b0 00 00 00 08 00
Buffer I/O error on device dm-0, logical block 6324224
lost page write due to I/O error on dm-0
JBD2: I/O error detected when updating journal superblock for dm-0-8.
EXT4-fs error (device dm-0): ext4_journal_start_sb: Detected aborted journal
EXT4-fs (dm-0): Remounting filesystem read-only
sd 0:1:0:0: [sda] Unhandled error code
sd 0:1:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 06 8e b6 00 00 00 08 00
Buffer I/O error on device dm-2, logical block 516288
lost page write due to I/O error on dm-2
JBD2: Detected IO errors while flushing file data on dm-2-8
sd 0:1:0:0: [sda] Unhandled error code
sd 0:1:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 1f 95 ba 40 00 00 10 00
Aborting journal on device dm-2-8.
sd 0:1:0:0: [sda] Unhandled error code
sd 0:1:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 1f 93 b0 00 00 00 08 00
Buffer I/O error on device dm-2, logical block 52985856
lost page write due to I/O error on dm-2
JBD2: I/O error detected when updating journal superblock for dm-2-8.
EXT4-fs error (device dm-2): ext4_journal_start_sb: Detected aborted journal
EXT4-fs (dm-2): Remounting filesystem read-only
mpt2sas0: _scsih_ir_shutdown: timeout
sd 0:1:0:0: RAID REMOVE
sd 0:1:0:0: RAID REMOVE DONE
mpt2sas0: removing handle(0x00aa), wwid(0x0d142348722f1016)
mpt2sas0: removing handle(0x0009), sas_addr(0x4433221100000000)
mpt2sas0: removing handle(0x000a), sas_addr(0x4433221101000000)
sd 0:0:2:0: [sdb] Synchronizing SCSI cache
sd 0:0:2:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
mpt2sas0: removing handle(0x000b), sas_addr(0x4433221102000000)
sd 0:0:3:0: [sdc] Synchronizing SCSI cache
sd 0:0:3:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
mpt2sas0: removing handle(0x000c), sas_addr(0x4433221103000000)
mpt2sas0: sending diag reset !!
mpt2sas0: diag reset: FAILED
mpt2sas 0000:01:00.0: PCI INT A disabled

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
