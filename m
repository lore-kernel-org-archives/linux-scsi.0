From: Nicola Ricciarelli <ricciare@aliceposta.it>
Subject: AHA1505 and 2.6.9 kernel
Date: Sat, 27 Nov 2004 09:23:54 +0100
Message-ID: <1101543834.3587.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp1alice.tin.it ([212.216.176.144]:45007 "EHLO
	vsmtp1alice.tin.it") by vger.kernel.org with ESMTP id S261156AbUK0IZZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Nov 2004 03:25:25 -0500
Received: from host112-166.pool80180.interbusiness.it (80.180.166.112) by vsmtp1alice.tin.it (7.0.027)
        id 414EFB8400486343 for linux-scsi@vger.kernel.org; Sat, 27 Nov 2004 09:25:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've a very old SCSI controller, ADAPTEC AHA1505, I use it just to
control an Epson GT5500 scanner. I know .. very old controller ^_* but
sufficient for a scanner. I've selected hardware jumpers of the
controller so it has I/O= 0x140 and IRQ=9  (the only one free IRQ using
windows .. IRQ=11 it has a conflict with ethernet card). The scanner has
ID=2.


* Adding    aha152x=0x140,9,2  in grub.conf nothing occurs
* Adding    aha152x=0x140,9    in grub.conf nothing occurs
* Adding    options aha152x aha152x=0x140,9,2  in /etc/modprobe.conf
and typing   modprobe aha152x nothing occurs
* Adding    options aha152x aha152x=0x140,9    in /etc/modprobe.conf
and typing   modprobe aha152x nothing occurs

all times it says:
 

Nov 27 09:22:03 localhost kernel: aha152x: BIOS test: passed, 1
controller(s) configured
Nov 27 09:22:05 localhost kernel: aha152x: resetting bus...
Nov 27 09:22:05 localhost kernel: aha152x3: vital data: rev=1, io=0x140
(0x140/0x140), irq
=9, scsiid=7, reconnect=enabled, parity=enabled, synchronous=disabled,
delay=1000, extende
d translation=disabled
Nov 27 09:22:05 localhost kernel: aha152x3: trying software interrupt,
lost.
Nov 27 09:22:05 localhost kernel: aha152x3: irq 9 possibly wrong.
Please verify.



Nicola
 

PS:  I was missing a couple of infos: I'm using Fedora Core 2 distro and
kernel 2.6.9-1.6_FC2 (but I'm going to recompile the 2.6.9 kernel +
patch 2.6.10-rc2).

-- 
Nicola Ricciarelli <ricciare@aliceposta.it>

