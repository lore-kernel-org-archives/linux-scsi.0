From: Daryl Zero <daryl0@nwlink.com>
Subject: sym53c8xx message d sent on bad reselection
Date: Sat, 17 Aug 2002 16:14:36 -0700 (Pacific Daylight Time)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.WNT.4.44.0208171558120.-336279@dbradfor.nwlink.com>
References: <3520000.1029614064@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from MERCURY (ip48.usw4.rb1.pdx.nwlink.com [207.202.183.48])
	by smtp001.nwlink.com (8.12.2/8.12.2) with ESMTP id g7HNEkHW027246
	for <linux-scsi@vger.kernel.org>; Sat, 17 Aug 2002 16:14:47 -0700
In-Reply-To: <3520000.1029614064@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi.. I'm new to this list and somewhat new to linux. I tend to be
technical in nature but I do not have a lot of experience with linux. I
have recently upgraded my home firewall box to Redhat 7.3. Everything
seems to work fine, except I am now having one problem with the SCSI disk
system.

The computer is a Compaq Professional Workstation 7000 with dual Pentium
Pro 200 processors (overclocked to 233). It has a sym53c875 SCSI
controller in the motherboard, and the factory Western Digital WDE2170W
2GB SCSI drive install internally. I have externally attached 4 Seagate
ST410800N 10GB SCSI drives, mounted on /disk1 thru /disk4 under linux. The
internal drive and the /disk4 external drive are terminated via jumper
settings on the drives.

The problem I'm having is that now it seems that if I start to copy or
write things to /disk2, it will work for awhile but then hang, and the
following message appears on the console:

> sym53c875-0:2: message d sent on bad reselection.
> scsi: aborting command due to timeout : pid 4125, scsi0, channel 0, id 2, lun 0
> Write (10) 00 00 0a 12 10 00 01 10 00
> sym53c8xx_abort: pid=4125 serial_number 4126
> serial_number_at_timeout=4126
> sym53c875-0:2: message d sent on bad reselection.
> scsi: aborting command due to timeout : pid 4199, scsi0, channel 0, id 2, lun 0
> Write (10) 00 00 0a 12 10 00 01 10 00
> sym53c8xx_abort: pid=4199 serial_number 4200
> serial_number_at_timeout=4200
> sym53c875-0:2: message d sent on bad reselection.
> SCSI host 0 abort (pid 4213) timed out - resetting
> SCSI bus is being reset for host 0 channel 0.
> sym53c8xx_reset: pid=4213 reset_flags=2 serial_number=4214
> serial_number_at_timeout=4214

Then the write operation finishes (I think). So I do something else on
that drive, and I get a similar set of console messages again. Then, the
console starts spitting out:

> sym53c875-0: SCSI phase error fixup: CCB already dequeued.

This message repeats about once ever second or two and just keeps on
repeating.

Can anyone tell me what might be wrong and what I ought to try?

David Bradford
Information Services Director, LPA, Inc.
Home: (503) 203-1043
Cell: (503) 341-9519

