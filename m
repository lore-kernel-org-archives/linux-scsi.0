From: Edward Matteucci <Tamagucci@libero.it>
Subject: strange scsi behaviour
Date: Wed, 18 Jun 2003 00:48:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030618004806.2bf21d62.Tamagucci@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 213-156-50-138.fastres.net ([213.156.50.138]:40346 "EHLO
	localhost") by vger.kernel.org with ESMTP id S265016AbTFQXve convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2003 19:51:34 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id EFF9420ADA
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2003 00:48:06 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have no scsi device but I think my problem is scsi related.

I have an i386 PC (MB asus a7v8x, Athlon XP, 512Mb Ram, 2 HD).
I use Debian Sid (the kernel was compiled using gcc-2.95).
I have two hd and two cdrom drive (the first one is a dvd,
the second one is a cd burner). I have also a pci-firewire card
to connect to my iPod.
My cdrw is "scsi-emulated" (hdx=3Dide-scsi) just to be backward
compatible (the dvd is a plain ide).
I have found that many howto suggest a script called "rescan-scsi-bus.s=
h"
to let the scsi-subsystem notice the newly plugged in iPod.
I have tried this script flawless, with my "old" 2.4.21-ac1, when
I tried the "new" 2.5.72 I have found this:
I have executed the .sh script before
cdrecord -scanbus (here is the output):
nice :-)

Linux sg driver version: 3.5.29
Cdrecord 2.01a15 (i686-pc-linux-gnu) Copyright (C) 1995-2003 J=F6rg Sch=
illing
Using libscg version 'schily-0.7'
scsibus0:
	0,0,0	  0) 'HL-DT-ST' 'CD-RW GCE-8400B ' '1.02' Removable CD-ROM
	0,1,0	  1) 'HL-DT-ST' 'CD-RW GCE-8400B ' '1.02' Removable CD-ROM
	0,2,0	  2) 'HL-DT-ST' 'CD-RW GCE-8400B ' '1.02' Removable CD-ROM
	0,3,0	  3) 'HL-DT-ST' 'CD-RW GCE-8400B ' '1.02' Removable CD-ROM
	0,4,0	  4) 'HL-DT-ST' 'CD-RW GCE-8400B ' '1.02' Removable CD-ROM
	0,5,0	  5) 'HL-DT-ST' 'CD-RW GCE-8400B ' '1.02' Removable CD-ROM
	0,6,0	  6) 'HL-DT-ST' 'CD-RW GCE-8400B ' '1.02' Removable CD-ROM
	0,7,0	  7) 'HL-DT-ST' 'CD-RW GCE-8400B ' '1.02' Removable CD-ROM
scsibus1:
	1,0,0	100) 'Apple   ' 'iPod            ' '1.30' Removable Disk
	1,1,0	101) *
	1,2,0	102) *
	1,3,0	103) *
	1,4,0	104) *
	1,5,0	105) *
	1,6,0	106) *
	1,7,0	107) *

if you need any other information, please cc me (I'm not subscribed
to this mailing list).

	Edward Matteucci

ps the script can be found on http://www.garloff.de/kurt/linux/rescan-s=
csi-bus.sh
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
