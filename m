From: "Kai Ruhnau" <kai@tragetaschen.dyndns.org>
Subject: Driver for Adaptec AHA-1530P
Date: Sat, 10 Jan 2004 01:26:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0af101c3d710$72c57e60$060ba8c0@AldiP4>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout08.sul.t-online.com ([194.25.134.20]:41409 "EHLO
	mailout08.sul.t-online.com") by vger.kernel.org with ESMTP
	id S264498AbUAJA10 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2004 19:27:26 -0500
Received: from AldiP4 (aldi-p4 [192.168.11.6])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by fileserver.ruhnau (Postfix) with ESMTP id CC6DA1DEC7
	for <linux-scsi@vger.kernel.org>; Sat, 10 Jan 2004 01:27:33 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have an old scsi-only P200. It has an Adaptec AHA-1530P ISA-board.

I had and have a running Kernel 2.4.10. It uses the driver aha152x
successfully. I tried to update to 2.4.16, 2.4.20 and now I try 2.4.24. All
show the same behaviour:

Kernel-parameter: 'aha152x=0x340'

<snip>
SCSI subsystem driver Revision: 1.00
aha152x: processing commandline: <3>
aha152x: 0x340
aha152x: Invalid line
ok
aha152x: BIOS test: passed, detected 1 controller(s)
aha152x: resetting bus...
aha152x0: vital data: rev=7, io=0x340 (0x340/0x340), irq=11, scsiid=7,
reconnect=enabled, parity=enabled, synchronous=enabled, delay=1000, extended
translation=disabled
aha152x0: trying software interrupt, ok.
scsi0 : Adaptec 152x SCSI driver; $Revision: 2.5 $
(long pause)
aha152x: ABORT timed out - removed from issue queue
scsi: device set offline - not ready or command retry failed after bus
reset: host 0 channel 0 id 0 lun 0
scsi: unknown type 22
Vendor: [crap] Model: [more crap] Rev:
Type: Unknown
(again long pause)
</snip>

And the last seven lines count up the lun and the id up to 'id 7 lun 7'.
After that, I end up with a kernel-panic due to the missing root-device.
The [crap] and [more crap] are always the same characters.

In kernel 2.6.0 the aha152x-driver does not find any appropiate device. Here
I also tried the aha1542, but I can't read any error, it scrolls up too
fast.


I know from the Changelogs that there were a couple of changes since 2.4.10,
but is it possible to convince the aha152x (or any other) driver to work
with my card?

Of course I'm willing to help everybody as I can.

Greetings
Kai

