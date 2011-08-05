From: Matt Turner <mattst88@gmail.com>
Subject: Re: 3Ware 9550SX on MIPS
Date: Fri, 5 Aug 2011 18:56:30 -0400
Message-ID: <CAEdQ38EzfPu+qVPEQtpqZ5zn9PqNtR82_C4N5Zezc8PLYgihMA@mail.gmail.com>
References: <CAEdQ38FKHh2+QdEz=e9HUEUg-miRYuRe730QEwsjbZYzUF28zg@mail.gmail.com>
 <CAHtARFHqjYAcw_KON_SWumY4XdD-0KbW3-NTveyLUAeYKiDang@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44341 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab1HEW4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2011 18:56:51 -0400
Received: by vws1 with SMTP id 1so2243253vws.19
        for <linux-scsi@vger.kernel.org>; Fri, 05 Aug 2011 15:56:50 -0700 (PDT)
In-Reply-To: <CAHtARFHqjYAcw_KON_SWumY4XdD-0KbW3-NTveyLUAeYKiDang@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Aug 5, 2011 at 6:49 PM, adam radford <aradford@gmail.com> wrote:
> On Fri, Aug 5, 2011 at 2:34 PM, Matt Turner <mattst88@gmail.com> wrote:
>
>> the card will fit in. I've tried 3Ware's tw_cli utility under qemu:
>
> That will not work.

Any particular reason? I can see in the strace output that it finds
the card in /sys/devices/pci*/host*/.

>> Are there any ways to configure this card through /proc or /sys? I
>> simply want to get the card to export the single disk to the OS.
>
> You can put the board and drive into an x86 box, hit alt-3 at 3ware
> option rom bios, configure a single disk raid unit, then put it back
> in your MIPS system.
>
> Unfortunately configuring the card through /proc or /sys would involve
> many thousands of lines of code (more than exist currently in the
> driver) to create and populate complex raid descriptor structures, and
> this code need not be in-kernel.

I'd be perfectly satisfied with an open source tw_cli I could use on MIPS.

> I have PPC32/64, but no MIPS box, otherwise I could build you a tw_cli
> binary that would work.

I do have a PowerMac G5 with 3.3V PCI-X. Could I configure it somehow with that?

Alternatively, I can easily give you ssh access to my MIPS system if
you'd be willing to compile tw_cli for MIPS. Send me your ssh key.

Thanks,
Matt
