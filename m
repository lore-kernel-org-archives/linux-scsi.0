From: Turbo Fredriksson <turbo@bayour.com>
Subject: Is mvsas still supported?
Date: Wed, 26 Nov 2014 15:07:44 +0100
Message-ID: <9EB2A663-04BF-4CC9-A5D9-B7FD6C53354A@bayour.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsp-authed01.binero.net ([195.74.38.224]:59638 "EHLO
	bin-vsp-out-05.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751134AbaK0ByD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2014 20:54:03 -0500
Received: from [192.168.69.225] (unknown [83.252.96.88])
	by bin-vsp-out-05.atm.binero.net (Halon Mail Gateway) with ESMTPSA
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2014 02:48:05 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm having a lot of troubles after adding a third AOC-SAS2LP-MV8 card. Worked
quite nicely with two, but with the third card I get a lot of 

[20190.510780] ata22.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[20190.511766] ata22.00: failed command: WRITE DMA EXT
[20190.512660] ata22.00: cmd 35/00:80:68:fe:d0/00:00:10:01:00/e0 tag 17 dma 65536 out
[20190.512660]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[20190.514557] ata22.00: status: { DRDY }
[48052.265328] ata21.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[48052.266364] ata21.00: failed command: WRITE DMA EXT
[48052.267344] ata21.00: cmd 35/00:00:a0:7a:dd/00:01:fc:00:00/e0 tag 29 dma 131072 out
[48052.267344]          res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask 0x4 (timeout)
[48052.269360] ata21.00: status: { DRDY }
[91595.340801] ata21.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[91595.341809] ata21.00: failed command: WRITE DMA EXT
[91595.342768] ata21.00: cmd 35/00:00:30:cb:4b/00:01:42:01:00/e0 tag 29 dma 131072 out
[91595.342768]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[91595.344676] ata21.00: status: { DRDY }

These two disks is (and it's always different disks), strangely enough (?), on the
oldest card (which never shown any problems before - if it had been the newest, one
could have considered hardware problems).

And shortly after this, the kernel hard locks, forcing the hardware watchdog to reset
the machine.

This is, currently, kernel version 3.18-rc3 (I've tried so many versions the last couple
of months), but I notice that the mvsas driver haven't had any real changes since 3.9 or
there a bouts (one of the first that actually worked,w which I tried about a year or so
ago).
--
Geologists recently discovered that "earthquakes" are
nothing more than Bruce Schneier and Chuck Norris
communicating via a roundhouse kick-based cryptosystem.

