From: "Joe Stump" <jstump@aa.acinc.com>
Subject: Phanton SCSI Array
Date: Tue, 6 May 2003 13:21:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <NLEBJHOBKIHHEMNADKPJOELFCAAA.jstump@aa.acinc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aa.acinc.com ([166.90.246.218]:49936 "HELO aa.acinc.com")
	by vger.kernel.org with SMTP id S263975AbTEFQ5X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2003 12:57:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm having a nightmare keeping my SCSI external RAID array alive on my
2.4.19 box. Here is my setup:

- Genesis RAID Array (all setup and working)
- Adaptec AHA-2940U SCSI adapter
- Debian GNU/Linux kernel 2.4.19
- EXT3 filesystem

When I boot up all appears to be well:

(scsi0) <Adaptec AHA-294X Ultra SCSI host adapter> found at PCI 0/16/0
(scsi0) Wide Channel, SCSI ID=7, 16/255 SCBs
(scsi0) Cables present (Int-50 NO, Int-68 NO, Ext-68 YES)
(scsi0) Downloading sequencer code... 436 instructions downloaded
scsi0 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.2.4/5.2.0
       <Adaptec AHA-294X Ultra SCSI host adapter>
  Vendor: MICRONET  Model: Genesis Ultra2    Rev: K1.1
  Type:   Direct-Access                      ANSI SCSI revision: 03
Attached scsi disk sda at scsi0, channel 0, id 1, lun 0
(scsi0:0:1:0) Synchronous at 40.0 Mbyte/sec, offset 8.
SCSI device sda: 179217280 512-byte hdwr sectors (91759 MB)
 sda: sda1

However, randomly, the RAID array borks, the kernel goes nuts trying to find
it and we crash:

May  6 10:00:05 hera kernel:  I/O error: dev 08:01, sector 107500104
May  6 10:00:05 hera kernel: Device 08:01 not ready.
May  6 10:00:05 hera kernel:  I/O error: dev 08:01, sector 107500104
May  6 10:00:05 hera kernel: Device 08:01 not ready.

Everything appears to be terminated correctly. The 2940U is on
autoterminate, the terminator on the Genesis is set (although I get a red
instead of a green light - whatever that means).

I'm not well informed when it comes to SCSI so I apologize in advance for
any stupid questions. I've searched all over the net for answers and I'm
coming up empty handed. Also, the Genesis says that everything is OK as far
as the array goes, but the odd part is my Linux box won't recognize it
correctly (keeps seeing 6 separate drives instead of a single RAID array)
after everything crashes.

--Joe

--
Joe Stump <joe@joestump.net>
http://www.joestump.net
"Label makers are proof God wants Sys Admins to be happy."

