From: "Mile Davidovic" <mile.davidovic@micronasnit.com>
Subject: ITE Radi 8212
Date: Sat, 13 Nov 2004 12:41:44 +0100
Message-ID: <200411131145.iADBjnV7024462@krt.neobee.net>
Reply-To: <mile.davidovic@micronasnit.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krt.neobee.net ([80.74.175.2]:2197 "EHLO krt.neobee.net")
	by vger.kernel.org with ESMTP id S261823AbUKMLl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Nov 2004 06:41:29 -0500
Received: from localhost (localhost [127.0.0.1])
	by krt.neobee.net (8.12.7/8.12.7/SuSE Linux 0.6) with ESMTP id iADBjr72024466
	for <linux-scsi@vger.kernel.org>; Sat, 13 Nov 2004 12:45:54 +0100
Received: from krt.neobee.net ([127.0.0.1])
 by localhost (krt.neobee.net [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 23733-08 for <linux-scsi@vger.kernel.org>;
 Sat, 13 Nov 2004 12:45:53 +0100 (CET)
Received: from davidovic ([192.168.0.89])
	by krt.neobee.net (8.12.7/8.12.7/SuSE Linux 0.6) with ESMTP id iADBjnV7024462
	for <linux-scsi@vger.kernel.org>; Sat, 13 Nov 2004 12:45:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi folks

I have trouble with IT8212F raid controller (on Gigabyte boards also known
as GigaRaid) on FedoraCore 3. 
There was some problem with building modules but after some fixing Makefile
I succeeded to build module. 

After loading module dmesg shows:
	Found Controller: IT8212 UDMA/ATA133 RAID Controller
	FindDevices: device 0 is IDE
	FindDevices: device 1 is IDE
	Channel[0] BM-DMA at 0xA400-0xA407
	Channel[1] BM-DMA at 0xA408-0xA40F
	scsi2 : ITE RAIDExpress133
	  Vendor: ITE       Model: IT8212F           Rev: 1.3
	  Type:   Direct-Access                      ANSI SCSI revision: 00
	SCSI device sdb: 488397166 512-byte hdwr sectors (250059 MB)
	sdb: asking for cache data failed
	sdb: assuming drive cache: write through
	 sdb: sdb1
	Attached scsi disk sdb at scsi2, channel 0, id 0, lun 0
	  Vendor: ITE       Model: IT8212F           Rev: 1.3
	  Type:   Direct-Access                      ANSI SCSI revision: 00
	SCSI device sdc: 488397166 512-byte hdwr sectors (250059 MB)
	sdc: asking for cache data failed
	sdc: assuming drive cache: write through
	 sdc:<4>atkbd.c: Unknown key pressed (translated set 2, code 0x0 on
isa0060/serio0).
	atkbd.c: Use 'setkeycodes 00 <keycode>' to make it known.
	atkbd.c: Unknown key pressed (translated set 2, code 0x0 on
isa0060/serio0).
	atkbd.c: Use 'setkeycodes 00 <keycode>' to make it known.
	 sdc1
	Attached scsi disk sdc at scsi2, channel 0, id 1, lun 0

[root@beowulf scsi]# mount /dev/sdb1 /mnt/
atkbd.c: Unknown key pressed (translated set 2, code 0x0 on isa0060/serio0).
atkbd.c: Use 'setkeycodes 00 <keycode>' to make it known.
...
atkbd.c: Unknown key pressed (translated set 2, code 0x0 on isa0060/serio0).
atkbd.c: Use 'setkeycodes 00 <keycode>' to make it known.
kjournald starting.  Commit interval 5 seconds
atkbd.c: Unknown key pressed (translated set 2, code 0x0 on isa0060/serio0).
atkbd.c: Use 'setkeycodes 00 <keycode>' to make it known.
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
atkbd.c: Unknown key pressed (translated set 2, code 0x0 on isa0060/serio0).
atkbd.c: Use 'setkeycodes 00 <keycode>' to make it known.

I found a lot of things over google but I didn't found any answer.

Thanks in a advice
Best regards Mile

Mile Davidovic, B.Sc.
--
Mile.Davidovic@micronasnit.com
MicronasNIT LLC.
http://www.micronasnit.com
Fruskogorska 11a, 21000 Novi Sad, Serbia & Montenegro Phone (1) : +381 (0)21
475 00 24 (ext. 111) Phone (2) : +381 (0)21 475 00 28 (ext. 112)
Fax           : +381 (0)21 450 721
 

