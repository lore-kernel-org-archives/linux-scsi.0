From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59301] mpt2sas0 fails after short time of work
Date: Wed,  3 Jul 2013 00:35:42 +0000 (UTC)
Message-ID: <20130703003542.3371311FA5F@bugzilla.kernel.org>
References: <bug-59301-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56986 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab3GCAfr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jul 2013 20:35:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6B85D20138
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2013 00:35:45 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9CD9A20125
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2013 00:35:42 +0000 (UTC)
In-Reply-To: <bug-59301-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59301


Marian Marinov <mm@yuhu.biz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mm@yuhu.biz




--- Comment #2 from Marian Marinov <mm@yuhu.biz>  2013-07-03 00:35:41 ---
I have similar problem with CentOS 6.4:

Jul  3 01:03:14 BlackPearl kernel: mpt2sas0: _base_fault_reset_work : SAS host
is non-operational !!!!
Jul  3 01:03:15 BlackPearl kernel: mpt2sas0: _base_fault_reset_work : SAS host
is non-operational !!!!
Jul  3 01:03:16 BlackPearl kernel: mpt2sas0: _base_fault_reset_work : SAS host
is non-operational !!!!
Jul  3 01:03:17 BlackPearl kernel: mpt2sas0: _base_fault_reset_work : SAS host
is non-operational !!!!
Jul  3 01:03:18 BlackPearl kernel: mpt2sas0: _base_fault_reset_work : SAS host
is non-operational !!!!
Jul  3 01:03:19 BlackPearl kernel: mpt2sas0: _base_fault_reset_work : SAS host
is non-operational !!!!
Jul  3 01:03:19 BlackPearl kernel: mpt2sas0: _base_fault_reset_work: Running
mpt2sas_dead_ioc thread success !!!!
Jul  3 01:03:19 BlackPearl kernel: mpt2sas0: IR shutdown (sending)
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] Unhandled error code
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] CDB: Write(10): 2a 00 07
55 40 28 00 00 08 00
Jul  3 01:03:19 BlackPearl kernel: Buffer I/O error on device dm-2, logical
block 9089541
Jul  3 01:03:19 BlackPearl kernel: lost page write due to I/O error on dm-2
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] Unhandled error code
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] CDB: Write(10): 2a 00 03
01 1f 48 00 00 08 00
Jul  3 01:03:19 BlackPearl kernel: Buffer I/O error on device dm-2, logical
block 11753
Jul  3 01:03:19 BlackPearl kernel: lost page write due to I/O error on dm-2
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] Unhandled error code
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] CDB: Write(10): 2a 00 06
04 06 98 00 00 18 00
Jul  3 01:03:19 BlackPearl kernel: JBD2: Detected IO errors while flushing file
data on dm-2-8
Jul  3 01:03:19 BlackPearl kernel: Aborting journal on device dm-2-8.
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] Unhandled error code
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] CDB: Write(10): 2a 00 06
03 b0 00 00 00 08 00
Jul  3 01:03:19 BlackPearl kernel: Buffer I/O error on device dm-2, logical
block 6324224
Jul  3 01:03:19 BlackPearl kernel: lost page write due to I/O error on dm-2
Jul  3 01:03:19 BlackPearl kernel: JBD2: I/O error detected when updating
journal superblock for dm-2-8.
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] Unhandled error code
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:1:0: [sdc] CDB: Write(10): 2a 00 07
55 40 28 00 00 08 00
Jul  3 01:03:19 BlackPearl kernel: Buffer I/O error on device dm-2, logical
block 9089541
Jul  3 01:03:19 BlackPearl kernel: lost page write due to I/O error on dm-2
Jul  3 01:03:19 BlackPearl kernel: JBD2: Detected IO errors while flushing file
data on dm-2-8
Jul  3 01:03:19 BlackPearl kernel: EXT4-fs error (device dm-2):
ext4_journal_start_sb: Detected aborted journal
Jul  3 01:03:19 BlackPearl kernel: EXT4-fs (dm-2): Remounting filesystem
read-only
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] Unhandled error code
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] CDB: Write(10): 2a 00 02
d2 bc d8 00 00 08 00
Jul  3 01:03:19 BlackPearl kernel: Buffer I/O error on device sdb2, logical
block 5792147
Jul  3 01:03:19 BlackPearl kernel: lost page write due to I/O error on sdb2
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] Unhandled error code
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] CDB: Write(10): 2a 00 02
d2 bc b8 00 00 08 00
Jul  3 01:03:19 BlackPearl kernel: Buffer I/O error on device sdb2, logical
block 5792143
Jul  3 01:03:19 BlackPearl kernel: lost page write due to I/O error on sdb2
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] Unhandled error code
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] CDB: Write(10): 2a 00 02
d2 bc 90 00 00 08 00
Jul  3 01:03:19 BlackPearl kernel: Buffer I/O error on device sdb2, logical
block 5792138
Jul  3 01:03:19 BlackPearl kernel: lost page write due to I/O error on sdb2
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] Unhandled error code
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] CDB: Write(10): 2a 00 02
6c 5f 98 00 00 10 00
Jul  3 01:03:19 BlackPearl kernel: Buffer I/O error on device sdb2, logical
block 4953579
Jul  3 01:03:19 BlackPearl kernel: lost page write due to I/O error on sdb2
Jul  3 01:03:19 BlackPearl kernel: Buffer I/O error on device sdb2, logical
block 4953580
Jul  3 01:03:19 BlackPearl kernel: lost page write due to I/O error on sdb2
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] Unhandled error code
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:19 BlackPearl kernel: sd 0:0:0:0: [sdb] CDB: Write(10): 2a 00 02
6c 5b b0 00 00 08 00
Jul  3 01:03:19 BlackPearl kernel: end_request: I/O error, dev sdb, sector
40656856
Jul  3 01:03:19 BlackPearl kernel: end_request: I/O error, dev sda, sector
319147287
Jul  3 01:03:19 BlackPearl kernel: JBD: Detected IO errors while flushing file
data on sdb2
Jul  3 01:03:19 BlackPearl kernel: end_request: I/O error, dev sdb, sector
1071616
Jul  3 01:03:19 BlackPearl kernel: Aborting journal on device sdb2.
Jul  3 01:03:19 BlackPearl kernel: end_request: I/O error, dev sdb, sector
1044600
Jul  3 01:03:19 BlackPearl kernel: JBD: I/O error detected when updating
journal superblock for sdb2.
Jul  3 01:03:19 BlackPearl kernel: end_request: I/O error, dev sda, sector
486837599
Jul  3 01:03:19 BlackPearl kernel: end_request: I/O error, dev sda, sector
16524759
Jul  3 01:03:19 BlackPearl kernel: JBD2: Detected IO errors while flushing file
data on sda1-8
Jul  3 01:03:19 BlackPearl kernel: Aborting journal on device sda1-8.
Jul  3 01:03:19 BlackPearl kernel: end_request: I/O error, dev sda, sector
486801471
Jul  3 01:03:19 BlackPearl kernel: JBD2: I/O error detected when updating
journal superblock for sda1-8.
Jul  3 01:03:24 BlackPearl kernel: __ratelimit: 7 callbacks suppressed
Jul  3 01:03:24 BlackPearl kernel: sd 0:1:0:0: [sda] Unhandled error code
Jul  3 01:03:24 BlackPearl kernel: sd 0:1:0:0: [sda] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:24 BlackPearl kernel: sd 0:1:0:0: [sda] CDB: Read(10): 28 00 2b 8d
4a 9f 00 00 10 00
Jul  3 01:03:24 BlackPearl kernel: __ratelimit: 7 callbacks suppressed
Jul  3 01:03:24 BlackPearl kernel: sd 0:1:0:0: [sda] Unhandled error code
Jul  3 01:03:24 BlackPearl kernel: sd 0:1:0:0: [sda] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:24 BlackPearl kernel: sd 0:1:0:0: [sda] CDB: Read(10): 28 00 2b 8d
4a 9f 00 00 08 00
Jul  3 01:03:24 BlackPearl kernel: sd 0:1:0:0: [sda] Unhandled error code
Jul  3 01:03:24 BlackPearl kernel: sd 0:1:0:0: [sda] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:24 BlackPearl kernel: sd 0:1:0:0: [sda] CDB: Read(10): 28 00 2b 8d
4a 9f 00 00 08 00
Jul  3 01:03:24 BlackPearl kernel: EXT4-fs error (device sda1):
ext4_journal_start_sb: Detected aborted journal
Jul  3 01:03:24 BlackPearl kernel: EXT4-fs (sda1): Remounting filesystem
read-only
Jul  3 01:03:26 BlackPearl kernel: EXT3-fs (sdb2): error:
ext3_journal_start_sb: Detected aborted journal
Jul  3 01:03:26 BlackPearl kernel: EXT3-fs (sdb2): error: remounting filesystem
read-only
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Unhandled error code
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] CDB: Read(10): 28 00 09 01
11 a7 00 00 08 00
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Unhandled error code
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] CDB: Read(10): 28 00 09 01
11 9f 00 00 08 00
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Unhandled error code
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 29
81 22 cf 00 00 08 00
Jul  3 01:03:27 BlackPearl kernel: __ratelimit: 6 callbacks suppressed
Jul  3 01:03:27 BlackPearl kernel: Buffer I/O error on device sda1, logical
block 87041106
Jul  3 01:03:27 BlackPearl kernel: lost page write due to I/O error on sda1
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Unhandled error code
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 2b
40 0c a7 00 00 08 00
Jul  3 01:03:27 BlackPearl kernel: Buffer I/O error on device sda1, logical
block 90702221
Jul  3 01:03:27 BlackPearl kernel: lost page write due to I/O error on sda1
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Unhandled error code
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 31
00 04 c7 00 00 08 00
Jul  3 01:03:27 BlackPearl kernel: Buffer I/O error on device sda1, logical
block 102760593
Jul  3 01:03:27 BlackPearl kernel: lost page write due to I/O error on sda1
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Unhandled error code
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 35
c0 04 17 00 00 08 00
Jul  3 01:03:27 BlackPearl kernel: Buffer I/O error on device sda1, logical
block 112722043
Jul  3 01:03:27 BlackPearl kernel: lost page write due to I/O error on sda1
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Unhandled error code
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:27 BlackPearl kernel: sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 00
00 00 3f 00 00 08 00
Jul  3 01:03:27 BlackPearl kernel: Buffer I/O error on device sda1, logical
block 0
Jul  3 01:03:27 BlackPearl kernel: lost page write due to I/O error on sda1
Jul  3 01:03:27 BlackPearl kernel: end_request: I/O error, dev sda, sector 143
Jul  3 01:03:27 BlackPearl kernel: Buffer I/O error on device sda1, logical
block 10
Jul  3 01:03:27 BlackPearl kernel: lost page write due to I/O error on sda1
Jul  3 01:03:27 BlackPearl kernel: end_request: I/O error, dev sda, sector
46956607
Jul  3 01:03:27 BlackPearl kernel: Buffer I/O error on device sda1, logical
block 5869568
Jul  3 01:03:27 BlackPearl kernel: lost page write due to I/O error on sda1
Jul  3 01:03:27 BlackPearl kernel: end_request: I/O error, dev sda, sector
52920383
Jul  3 01:03:27 BlackPearl kernel: Buffer I/O error on device sda1, logical
block 6615040
Jul  3 01:03:27 BlackPearl kernel: lost page write due to I/O error on sda1
Jul  3 01:03:27 BlackPearl kernel: end_request: I/O error, dev sda, sector
151019079
Jul  3 01:03:27 BlackPearl kernel: Buffer I/O error on device sda1, logical
block 18877377
Jul  3 01:03:27 BlackPearl kernel: lost page write due to I/O error on sda1
Jul  3 01:03:27 BlackPearl kernel: end_request: I/O error, dev sda, sector
318767175
Jul  3 01:03:27 BlackPearl kernel: Buffer I/O error on device sda1, logical
block 39845889
Jul  3 01:03:27 BlackPearl kernel: lost page write due to I/O error on sda1
Jul  3 01:03:27 BlackPearl kernel: end_request: I/O error, dev sda, sector
318767247
Jul  3 01:03:27 BlackPearl kernel: end_request: I/O error, dev sda, sector
322961599
Jul  3 01:03:27 BlackPearl kernel: end_request: I/O error, dev sda, sector
322961743
Jul  3 01:03:27 BlackPearl kernel: end_request: I/O error, dev sda, sector
696260503
Jul  3 01:03:29 BlackPearl kernel: mpt2sas0: _scsih_ir_shutdown: timeout
Jul  3 01:03:29 BlackPearl kernel: sd 0:1:0:0: RAID REMOVE
Jul  3 01:03:29 BlackPearl kernel: sd 0:1:0:0: RAID REMOVE DONE
Jul  3 01:03:29 BlackPearl kernel: mpt2sas0: removing handle(0x0143),
wwid(0x0823bf8f3c7d6391)
Jul  3 01:03:29 BlackPearl kernel: sd 0:0:0:0: [sdb] Synchronizing SCSI cache
Jul  3 01:03:29 BlackPearl kernel: sd 0:0:0:0: [sdb] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:29 BlackPearl kernel: mpt2sas0: removing handle(0x0009),
sas_addr(0x4433221100000000)
Jul  3 01:03:29 BlackPearl kernel: sd 0:0:1:0: [sdc] Synchronizing SCSI cache
Jul  3 01:03:29 BlackPearl kernel: sd 0:0:1:0: [sdc] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 01:03:29 BlackPearl kernel: mpt2sas0: removing handle(0x000a),
sas_addr(0x4433221103000000)
Jul  3 01:03:29 BlackPearl kernel: mpt2sas0: removing handle(0x000b),
sas_addr(0x4433221101000000)
Jul  3 01:03:29 BlackPearl kernel: mpt2sas0: removing handle(0x000c),
sas_addr(0x4433221102000000)
Jul  3 01:03:29 BlackPearl kernel: mpt2sas0: sending diag reset !!
Jul  3 01:03:29 BlackPearl kernel: mpt2sas0: diag reset: FAILED
Jul  3 01:03:29 BlackPearl kernel: mpt2sas 0000:02:00.0: PCI INT A disabled
Jul  3 01:03:29 BlackPearl kernel: EXT4-fs error (device sda1):
ext4_find_entry: 
Jul  3 01:03:29 BlackPearl kernel: EXT4-fs error (device sda1):
ext4_find_entry: reading directory #22032283 offset 0
Jul  3 01:03:29 BlackPearl kernel: EXT4-fs error (device sda1):
ext4_find_entry: reading directory #22032283 offset 0
Jul  3 01:03:29 BlackPearl kernel: reading directory #22032300 offset 0
Jul  3 01:03:29 BlackPearl kernel: EXT4-fs error (device sda1):
ext4_find_entry: reading directory #22032300 offset 0
Jul  3 01:03:36 BlackPearl kernel: __ratelimit: 4 callbacks suppressed
Jul  3 01:03:36 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 1716737
Jul  3 01:03:36 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:36 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 1716740
Jul  3 01:03:36 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:36 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 1583834
Jul  3 01:03:36 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:36 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 1583871
Jul  3 01:03:36 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:36 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 3146593
Jul  3 01:03:36 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:36 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 0
Jul  3 01:03:36 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:36 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 1
Jul  3 01:03:36 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:36 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 1662
Jul  3 01:03:36 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:36 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 1572880
Jul  3 01:03:36 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:36 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 1572896
Jul  3 01:03:36 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:41 BlackPearl kernel: __ratelimit: 3 callbacks suppressed
Jul  3 01:03:41 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 1716737
Jul  3 01:03:41 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:41 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 1716740
Jul  3 01:03:41 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:41 BlackPearl kernel: Aborting journal on device dm-0-8.
Jul  3 01:03:41 BlackPearl kernel: Buffer I/O error on device dm-0, logical
block 2129920
Jul  3 01:03:41 BlackPearl kernel: lost page write due to I/O error on dm-0
Jul  3 01:03:41 BlackPearl kernel: JBD2: I/O error detected when updating
journal superblock for dm-0-8.
Jul  3 01:03:41 BlackPearl kernel: EXT4-fs error (device dm-0):
ext4_journal_start_sb: Detected aborted journal
Jul  3 01:03:41 BlackPearl kernel: EXT4-fs (dm-0): Remounting filesystem
read-only
Jul  3 01:03:42 BlackPearl kernel: EXT4-fs error (device sda1):
ext4_find_entry: reading directory #22814427 offset 0

After reboot everything is fine, without any loss of data.
It seams like the controller freezes and drops all of the drives connected to
it. 
The logs were collected over the network.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
