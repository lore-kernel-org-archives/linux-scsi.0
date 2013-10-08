From: Sarah Brofeldt <sbrofeldt@gmail.com>
Subject: Fwd: mpt2sas fault_state(0x5851) with WD20EARX drives on LSI 9211 8i
Date: Tue, 8 Oct 2013 11:36:58 +0200
Message-ID: <CAJXHQe_E_DL8E2aCL8g_axgRPyHExf03XY5D6+F6W=i49V8KoA@mail.gmail.com>
References: <CAJXHQe9tHgP0TiEeRcKWKDZreQE6vJ2V8k+QPVP3ubDKB4zcsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:56478 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab3JHJhA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Oct 2013 05:37:00 -0400
Received: by mail-we0-f176.google.com with SMTP id w62so6641980wes.21
        for <linux-scsi@vger.kernel.org>; Tue, 08 Oct 2013 02:36:59 -0700 (PDT)
In-Reply-To: <CAJXHQe9tHgP0TiEeRcKWKDZreQE6vJ2V8k+QPVP3ubDKB4zcsA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

I'm wondering where to find information on the specific error codes
mpt2sas spits out. I'm experiencing fault_state(0x5851) which is
rendering my system unusable whenever I try to write to any of the
WD20EARX drives. I've appended a dmesg snippet of the problem to this
message.

I apologize if this is the completely wrong place to ask this kind of
question - I've been unable to find any information on the issue
elsewhere.

Thanks!
Sarah

-- dmesg --
Sep 19 01:22:28 pantheon kernel: [ 1879.320056] mpt2sas0: fault_state(0x5851)!
Sep 19 01:22:28 pantheon kernel: [ 1879.320534] mpt2sas0: sending diag reset !!
Sep 19 01:22:29 pantheon kernel: [ 1880.264573] mpt2sas0: diag reset: SUCCESS
Sep 19 01:22:30 pantheon kernel: [ 1880.497398] mpt2sas0: LSISAS2008:
FWVersion(17.00.01.00), ChipRevision(0x03), BiosVersion(07.24.01.00)
Sep 19 01:22:30 pantheon kernel: [ 1880.497403] mpt2sas0:
Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot
Buffer,Diag Trace Buffer,Task Set Full,NCQ)
Sep 19 01:22:30 pantheon kernel: [ 1880.497467] mpt2sas0: sending port enable !!
Sep 19 01:22:37 pantheon kernel: [ 1888.182686] mpt2sas0: port enable: SUCCESS
Sep 19 01:22:37 pantheon kernel: [ 1888.182904] mpt2sas0: search for
end-devices: start
Sep 19 01:22:37 pantheon kernel: [ 1888.183901] scsi target0:0:0:
handle(0x0009), sas_addr(0x4433221101000000), enclosure logical
id(0x500605b0054dd3c0), slot(2)
Sep 19 01:22:37 pantheon kernel: [ 1888.183987] scsi target0:0:2:
handle(0x000a), sas_addr(0x4433221102000000), enclosure logical
id(0x500605b0054dd3c0), slot(1)
Sep 19 01:22:37 pantheon kernel: [ 1888.183991]         handle changed
from(0x000b)!!!
Sep 19 01:22:37 pantheon kernel: [ 1888.184074] scsi target0:0:1:
handle(0x000b), sas_addr(0x4433221103000000), enclosure logical
id(0x500605b0054dd3c0), slot(0)
Sep 19 01:22:37 pantheon kernel: [ 1888.184077]         handle changed
from(0x000a)!!!
Sep 19 01:22:37 pantheon kernel: [ 1888.184159] scsi target0:0:3:
handle(0x000c), sas_addr(0x4433221106000000), enclosure logical
id(0x500605b0054dd3c0), slot(5)
Sep 19 01:22:37 pantheon kernel: [ 1888.184243] scsi target0:0:4:
handle(0x000d), sas_addr(0x4433221107000000), enclosure logical
id(0x500605b0054dd3c0), slot(4)
Sep 19 01:22:37 pantheon kernel: [ 1888.184322] mpt2sas0: search for
end-devices: complete
Sep 19 01:22:37 pantheon kernel: [ 1888.184325] mpt2sas0: search for
expanders: start
Sep 19 01:22:37 pantheon kernel: [ 1888.184327] mpt2sas0: search for
expanders: complete
Sep 19 01:22:37 pantheon kernel: [ 1888.184336] mpt2sas0: search for
end-devices: start
Sep 19 01:22:37 pantheon kernel: [ 1888.185249] scsi target0:0:0:
handle(0x0009), sas_addr(0x4433221101000000), enclosure logical
id(0x500605b0054dd3c0), slot(2)
Sep 19 01:22:37 pantheon kernel: [ 1888.185334] scsi target0:0:2:
handle(0x000a), sas_addr(0x4433221102000000), enclosure logical
id(0x500605b0054dd3c0), slot(1)
Sep 19 01:22:37 pantheon kernel: [ 1888.185416] scsi target0:0:1:
handle(0x000b), sas_addr(0x4433221103000000), enclosure logical
id(0x500605b0054dd3c0), slot(0)
Sep 19 01:22:37 pantheon kernel: [ 1888.185500] scsi target0:0:3:
handle(0x000c), sas_addr(0x4433221106000000), enclosure logical
id(0x500605b0054dd3c0), slot(5)
Sep 19 01:22:37 pantheon kernel: [ 1888.185583] scsi target0:0:4:
handle(0x000d), sas_addr(0x4433221107000000), enclosure logical
id(0x500605b0054dd3c0), slot(4)
Sep 19 01:22:37 pantheon kernel: [ 1888.185662] mpt2sas0: search for
end-devices: complete
Sep 19 01:22:37 pantheon kernel: [ 1888.185665] mpt2sas0: search for
expanders: start
Sep 19 01:22:37 pantheon kernel: [ 1888.185667] mpt2sas0: search for
expanders: complete
Sep 19 01:22:37 pantheon kernel: [ 1888.185674] mpt2sas0:
_base_fault_reset_work: hard reset: success
Sep 19 01:22:37 pantheon kernel: [ 1888.185679] mpt2sas0: removing
unresponding devices: start
Sep 19 01:22:37 pantheon kernel: [ 1888.185681] mpt2sas0: removing
unresponding devices: end-devices
Sep 19 01:22:37 pantheon kernel: [ 1888.185683] mpt2sas0: removing
unresponding devices: expanders
Sep 19 01:22:37 pantheon kernel: [ 1888.185686] mpt2sas0: removing
unresponding devices: complete
Sep 19 01:22:37 pantheon kernel: [ 1888.185694] mpt2sas0: scan devices: start
Sep 19 01:22:37 pantheon kernel: [ 1888.187320] mpt2sas0: scan devices: complete
Sep 19 01:22:38 pantheon kernel: [ 1889.185534] mpt2sas0: fault_state(0x5851)!
