From: Mark de Vries <linux-scsi@porch.ws>
Subject: ncr53c8xx errors & reset
Date: Sun, 18 Jan 2004 19:54:30 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0401181944080.854@fgevxr.nfculk.yna>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from porch.xs4all.nl ([80.126.78.181]:8196 "EHLO porch.xs4all.nl")
	by vger.kernel.org with ESMTP id S262888AbUARSyc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 13:54:32 -0500
Received: from strike.asphyx.lan (strike.asphyx.lan [192.168.0.2])
	by porch.xs4all.nl (Postfix) with ESMTP id DDE0A12BD2
	for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2004 19:54:30 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

Any idea what might be causing the errors below?

Hardware is in an old P60 I'm using as router/firewall/etc... And I get
an error like the one below every 2/3 weeks... and It's starting to worry
me. Should I start looking for a new disk or controller??

TIA & Regards,
Mark.

Linux version 2.4.25-pre4 (gcc version 2.95.4 20011002 (Debian prerelease)

ncr53c8xx: at PCI bus 0, device 6, function 0
ncr53c8xx: 53c810 detected
ncr53c810-0: rev 0x2 on pci bus 0 device 6 function 0 irq 11
ncr53c810-0: ID 7, Fast-10, Parity Checking
scsi0 : ncr53c8xx-3.4.3b-20010512
  Vendor: QUANTUM   Model: FIREBALL SE6.4S   Rev: PJ0A
  Type:   Direct-Access                      ANSI SCSI revision: 02
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
ncr53c810-0-<0,*>: FAST-10 SCSI 10.0 MB/s (100 ns, offset 8)
SCSI device sda: 12666022 512-byte hdwr sectors (6485 MB)
Partition check:
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >

scsi : aborting command due to timeout : pid 3990, scsi0, channel 0, id 0,
lun 0 0x28 00 00 63 64 f6 00 00 fe 00
ncr53c8xx_abort: pid=3990 serial_number=3991 serial_number_at_timeout=3991
scsi : aborting command due to timeout : pid 3991, scsi0, channel 0, id 0,
lun 0 0x28 00 00 63 65 f4 00 00 02 00
ncr53c8xx_abort: pid=3991 serial_number=3992 serial_number_at_timeout=3992
scsi : aborting command due to timeout : pid 3992, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 04 00 58 00 00 04 00
ncr53c8xx_abort: pid=3992 serial_number=3993 serial_number_at_timeout=3993
scsi : aborting command due to timeout : pid 3993, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 04 00 5e 00 00 04 00
ncr53c8xx_abort: pid=3993 serial_number=3994 serial_number_at_timeout=3994
scsi : aborting command due to timeout : pid 3994, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 04 00 64 00 00 02 00
ncr53c8xx_abort: pid=3994 serial_number=3995 serial_number_at_timeout=3995
scsi : aborting command due to timeout : pid 3995, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 04 00 6e 00 00 02 00
ncr53c8xx_abort: pid=3995 serial_number=3996 serial_number_at_timeout=3996
scsi : aborting command due to timeout : pid 3996, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 04 00 72 00 00 06 00
ncr53c8xx_abort: pid=3996 serial_number=3997 serial_number_at_timeout=3997
scsi : aborting command due to timeout : pid 3997, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 04 00 7a 00 00 0a 00
ncr53c8xx_abort: pid=3997 serial_number=3998 serial_number_at_timeout=3998
scsi : aborting command due to timeout : pid 3998, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 04 40 46 00 00 02 00
ncr53c8xx_abort: pid=3998 serial_number=3999 serial_number_at_timeout=3999
ncr53c810-0: abort ccb=c5c4d000 (cancel)
scsi : aborting command due to timeout : pid 3999, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 04 40 4e 00 00 02 00
ncr53c8xx_abort: pid=3999 serial_number=4000 serial_number_at_timeout=4000
ncr53c810-0: abort ccb=c5c4d800 (cancel)
scsi : aborting command due to timeout : pid 4000, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 04 40 58 00 00 02 00
ncr53c8xx_abort: pid=4000 serial_number=4001 serial_number_at_timeout=4001
ncr53c810-0: abort ccb=c2d5a000 (cancel)
scsi : aborting command due to timeout : pid 4001, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 05 40 44 00 00 02 00
ncr53c8xx_abort: pid=4001 serial_number=4002 serial_number_at_timeout=4002
ncr53c810-0: abort ccb=c2d5a800 (cancel)
scsi : aborting command due to timeout : pid 4002, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 05 40 48 00 00 02 00
ncr53c8xx_abort: pid=4002 serial_number=4003 serial_number_at_timeout=4003
ncr53c810-0: abort ccb=c2d5b000 (cancel)
scsi : aborting command due to timeout : pid 4003, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 06 80 44 00 00 02 00
ncr53c8xx_abort: pid=4003 serial_number=4004 serial_number_at_timeout=4004
ncr53c810-0: abort ccb=c2d5b800 (cancel)
scsi : aborting command due to timeout : pid 4004, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 00 80 44 00 00 04 00
ncr53c8xx_abort: pid=4004 serial_number=4005 serial_number_at_timeout=4005
ncr53c810-0: abort ccb=c2d58000 (cancel)
scsi : aborting command due to timeout : pid 4005, scsi0, channel 0, id 0,
lun 0 0x2a 00 00 00 80 4e 00 00 02 00
ncr53c8xx_abort: pid=4005 serial_number=4006 serial_number_at_timeout=4006
ncr53c810-0: abort ccb=c2d58800 (cancel)
SCSI host 0 abort (pid 3990) timed out - resetting
SCSI bus is being reset for host 0 channel 0.
ncr53c8xx_reset: pid=3990 reset_flags=2 serial_number=3991
serial_number_at_timeout=3991
ncr53c810-0-<0,*>: FAST-10 SCSI 10.0 MB/s (100 ns, offset 8)



