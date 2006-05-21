From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 6593] New: Plextor CDR PX-W4012 and kernel >
 2.6.13
Date: Sun, 21 May 2006 12:21:56 -0700
Message-ID: <20060521122156.3dc70bd9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32394 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964918AbWEUTWF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 May 2006 15:22:05 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id k4LJM3tH031221
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 21 May 2006 12:22:03 -0700
Received: from bix (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id k4LJM3sr002611
	for <linux-scsi@vger.kernel.org>; Sun, 21 May 2006 12:22:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


A regression..

Begin forwarded message:

Date: Sun, 21 May 2006 10:34:50 -0700
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 6593] New: Plextor CDR PX-W4012 and kernel > 2.6.13


http://bugzilla.kernel.org/show_bug.cgi?id=6593

           Summary: Plextor CDR PX-W4012 and kernel > 2.6.13
    Kernel Version: 2.6.14 and higher version
            Status: NEW
          Severity: normal
             Owner: scsi_drivers-other@kernel-bugs.osdl.org
         Submitter: nkieffer@gon0s.com


Most recent kernel where this bug did not occur: vanilla 2.6.17-rc4
Distribution: Gentoo
Hardware Environment: Adaptec SCSI Card 29160, MSI K7-Master Motherboard
Software Environment: kernel 2.6.14 and higher
Problem Description:
When I upgraded the kernel from Vanilla 2.6.13.4 to 2.6.14.x and higher, the
plextor CDR PX-W4012 (SCSI ID 3) is encountering errors when inserting and
mounting a CD. The scsi channel is then restarted again and again.
The weird thing is the Plextor SCSI CD-ROM PX-40TS reader is not impacted by
this issue. So it does only impact some specific drives.

I do not think it is related to this bug :
http://bugzilla.kernel.org/show_bug.cgi?id=5659

Using older kernel (<2.6.14 series) do not show this issue ! I even tried latest
 gentoo kernel available and the same problem occur, whereas the gentoo 2.6.16r7
almost permit to access to CD between 2 channel reset.

--------------DMESG-----------------------------------------------------------
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 17
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 29160 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

  Vendor: QUANTUM   Model: ATLAS10K2-TY184L  Rev: DDD6
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
 target0:0:0: Beginning Domain Validation
 target0:0:0: wide asynchronous
 target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target0:0:0: Ending Domain Validation
  Vendor: MAXTOR    Model: ATLAS10K4_36WLS   Rev: DFV0
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
 target0:0:1: Beginning Domain Validation
 target0:0:1: wide asynchronous
 target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target0:0:1: Ending Domain Validation
  Vendor: MAXTOR    Model: ATLAS10K4_36WLS   Rev: DFV0
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:2:0: Tagged Queuing enabled.  Depth 32
 target0:0:2: Beginning Domain Validation
 target0:0:2: wide asynchronous
 target0:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target0:0:2: Ending Domain Validation
  Vendor: PLEXTOR   Model: CD-R   PX-W4012S  Rev: 1.05
  Type:   CD-ROM                             ANSI SCSI revision: 02
 target0:0:3: Beginning Domain Validation
 target0:0:3: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
 target0:0:3: Domain Validation skipping write tests
 target0:0:3: Ending Domain Validation
  Vendor: PLEXTOR   Model: CD-ROM PX-40TS    Rev: 1.14
  Type:   CD-ROM                             ANSI SCSI revision: 02
 target0:0:4: Beginning Domain Validation
 target0:0:4: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
 target0:0:4: Domain Validation skipping write tests
 target0:0:4: Ending Domain Validation
SCSI device sda: 35860910 512-byte hdwr sectors (18361 MB)
sda: Write Protect is off
sda: Mode Sense: f5 00 10 08
SCSI device sda: drive cache: write back w/ FUA
SCSI device sda: 35860910 512-byte hdwr sectors (18361 MB)
sda: Write Protect is off
sda: Mode Sense: f5 00 10 08
SCSI device sda: drive cache: write back w/ FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
SCSI device sdb: 71833096 512-byte hdwr sectors (36779 MB)
sdb: Write Protect is off
sdb: Mode Sense: ed 00 10 08
SCSI device sdb: drive cache: write back w/ FUA
SCSI device sdb: 71833096 512-byte hdwr sectors (36779 MB)
sdb: Write Protect is off
sdb: Mode Sense: ed 00 10 08
SCSI device sdb: drive cache: write back w/ FUA
 sdb: sdb1 sdb2 < sdb5 >
sd 0:0:1:0: Attached scsi disk sdb
SCSI device sdc: 71833096 512-byte hdwr sectors (36779 MB)
sdc: Write Protect is off
sdc: Mode Sense: ed 00 10 08
SCSI device sdc: drive cache: write back w/ FUA
SCSI device sdc: 71833096 512-byte hdwr sectors (36779 MB)
sdc: Write Protect is off
sdc: Mode Sense: ed 00 10 08
SCSI device sdc: drive cache: write back w/ FUA
 sdc: sdc1 sdc2 < sdc5 >
sd 0:0:2:0: Attached scsi disk sdc
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
sr 0:0:3:0: Attached scsi CD-ROM sr0
sr1: scsi-1 drive
sr 0:0:4:0: Attached scsi CD-ROM sr1
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: Attached scsi generic sg1 type 0
sd 0:0:2:0: Attached scsi generic sg2 type 0
sr 0:0:3:0: Attached scsi generic sg3 type 5
sr 0:0:4:0: Attached scsi generic sg4 type 5
 --snip--

After inserting a CD in the tray and pmount/hal trying to mount it :

-- DMESG new messages with Vanilla kernel 2.6.14 ------------------------------
sr0: Hmm, seems the drive doesn't support multisession CD's
 target0:0:3: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
 (scsi0:A:3:0): No or incomplete CDB sent to device.
 scsi0: Issued Channel A Bus Reset. 1 SCBs aborted
 (scsi0:A:3:0): No or incomplete CDB sent to device.
 (scsi0:A:3:0): Protocol violation in Message-in phase.  Attempting to abort.
 (scsi0:A:3:0): Unexpected busfree in Message-in phase
 SEQADDR == 0x16c
 (scsi0:A:3:0): No or incomplete CDB sent to device.
 scsi0: Issued Channel A Bus Reset. 1 SCBs aborted
 (scsi0:A:3:0): No or incomplete CDB sent to device.
 (scsi0:A:3:0): Protocol violation in Message-in phase.  Attempting to abort.
 (scsi0:A:3:0): Unexpected busfree in Message-in phase
 SEQADDR == 0x16c
 (scsi0:A:3:0): No or incomplete CDB sent to device.
 scsi0: Issued Channel A Bus Reset. 1 SCBs aborted
 sr 0:0:3:0: SCSI error: return code = 0x70000

--DMESG new message with Gentoo kernel 2.6.16r7-------------------------------
(scsi0:A:3:0): No or incomplete CDB sent to device.
scsi0: Issued Channel A Bus Reset. 1 SCBs aborted
sr 0:0:3:0: SCSI error: return code = 0x10002
end_request: I/O error, dev sr0, sector 63128
Buffer I/O error on device sr0, logical block 15782
(scsi0:A:3:0): No or incomplete CDB sent to device.
scsi0: Issued Channel A Bus Reset. 1 SCBs aborted
VFS: busy inodes on changed media.
(scsi0:A:3:0): No or incomplete CDB sent to device.
scsi0: Issued Channel A Bus Reset. 1 SCBs aborted


Steps to reproduce: insert a CD in the tray, close the door and wait the volume
is mounted by pmount (or manually mounted doing the same result)

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
