From: Daniel Brahneborg <basic@chello.se>
Subject: ATAPI errors when using cdrecord
Date: Sun, 26 Jan 2003 18:46:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030126184644.A10278@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Daniel Brahneborg <basic@chello.se>

Hi,

I'm using cdrecord to burn CD's with a Philips CDRW48A burner,
and sometimes I get all kinds of errors with it.

 1. When interrupting a burn, the cd tray is locked and the
    machine must be rebooted.

 2. When burning a CD in disk-at-once mode, the computer froze
    and the CapsLock and ScrollLock leds started blinking.

A sample from my kernel log follows.  I'm currently using 
kernel 2.4.20, completely unpatched.

Is there anything I can do to make these errors go away?

Yours,

/Basic

Jan 26 15:27:37 nettis kernel: scsi : aborting command due to timeout :
pid 56000, scsi0, channel 0, id 0, lun
 0 0x2a 00 00 05 b1 11 00 00 1f 00
Jan 26 15:27:37 nettis kernel: hdd: irq timeout: status=0xd0 { Busy }
Jan 26 15:27:37 nettis kernel: hdd: ATAPI reset complete
Jan 26 15:27:37 nettis kernel: hdd: irq timeout: status=0xd0 { Busy }
Jan 26 15:27:37 nettis kernel: hdd: ATAPI reset complete
Jan 26 15:27:37 nettis kernel: hdd: status timeout: status=0xc0 { Busy }
Jan 26 15:27:37 nettis kernel: ide-scsi: Strange, packet command
initiated yet DRQ isn't asserted
Jan 26 15:27:42 nettis kernel: hdd: status timeout: status=0xd0 { Busy }
Jan 26 15:27:42 nettis kernel: ide-scsi: Strange, packet command
initiated yet DRQ isn't asserted
Jan 26 15:27:42 nettis kernel: hdd: ATAPI reset complete
Jan 26 15:27:42 nettis kernel: hdd: status timeout: status=0xd0 { Busy }
Jan 26 15:27:42 nettis kernel: ide-scsi: Strange, packet command
initiated yet DRQ isn't asserted
Jan 26 15:27:42 nettis kernel: hdd: ATAPI reset complete
Jan 26 15:27:42 nettis kernel: hdd: status timeout: status=0xd0 { Busy }
Jan 26 15:27:42 nettis kernel: ide-scsi: Strange, packet command
initiated yet DRQ isn't asserted
Jan 26 15:27:42 nettis kernel: hdd: status timeout: status=0xd0 { Busy }
Jan 26 15:27:42 nettis kernel: ide-scsi: Strange, packet command
initiated yet DRQ isn't asserted
Jan 26 15:27:42 nettis kernel: hdd: ATAPI reset complete
Jan 26 15:27:42 nettis kernel: hdd: status timeout: status=0xd1 { Busy }
Jan 26 15:27:42 nettis kernel: ide-scsi: Strange, packet command
initiated yet DRQ isn't asserted
Jan 26 15:27:43 nettis kernel: hdd: ATAPI reset complete
Jan 26 15:27:43 nettis kernel: hdd: status timeout: status=0xd0 { Busy }

