From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Driver for Adaptec AHA-1530P
Date: Sat, 10 Jan 2004 13:48:50 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401101348010.9458-100000@poirot.grange>
References: <0af101c3d710$72c57e60$060ba8c0@AldiP4>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:54178 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265150AbUAJMt2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2004 07:49:28 -0500
In-Reply-To: <0af101c3d710$72c57e60$060ba8c0@AldiP4>
List-Id: linux-scsi@vger.kernel.org
To: Kai Ruhnau <kai@tragetaschen.dyndns.org>
Cc: linux-scsi@vger.kernel.org

Hi

Can you send the relevant lines from 2.4.10 boot?

Cheers
Guennadi

On Sat, 10 Jan 2004, Kai Ruhnau wrote:

> Hi,
>
> I have an old scsi-only P200. It has an Adaptec AHA-1530P ISA-board.
>
> I had and have a running Kernel 2.4.10. It uses the driver aha152x
> successfully. I tried to update to 2.4.16, 2.4.20 and now I try 2.4.24. All
> show the same behaviour:
>
> Kernel-parameter: 'aha152x=0x340'
>
> <snip>
> SCSI subsystem driver Revision: 1.00
> aha152x: processing commandline: <3>
> aha152x: 0x340
> aha152x: Invalid line
> ok
> aha152x: BIOS test: passed, detected 1 controller(s)
> aha152x: resetting bus...
> aha152x0: vital data: rev=7, io=0x340 (0x340/0x340), irq=11, scsiid=7,
> reconnect=enabled, parity=enabled, synchronous=enabled, delay=1000, extended
> translation=disabled
> aha152x0: trying software interrupt, ok.
> scsi0 : Adaptec 152x SCSI driver; $Revision: 2.5 $
> (long pause)
> aha152x: ABORT timed out - removed from issue queue
> scsi: device set offline - not ready or command retry failed after bus
> reset: host 0 channel 0 id 0 lun 0
> scsi: unknown type 22
> Vendor: [crap] Model: [more crap] Rev:
> Type: Unknown
> (again long pause)
> </snip>
>
> And the last seven lines count up the lun and the id up to 'id 7 lun 7'.
> After that, I end up with a kernel-panic due to the missing root-device.
> The [crap] and [more crap] are always the same characters.
>
> In kernel 2.6.0 the aha152x-driver does not find any appropiate device. Here
> I also tried the aha1542, but I can't read any error, it scrolls up too
> fast.
>
>
> I know from the Changelogs that there were a couple of changes since 2.4.10,
> but is it possible to convince the aha152x (or any other) driver to work
> with my card?
>
> Of course I'm willing to help everybody as I can.
>
> Greetings
> Kai
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

---
Guennadi Liakhovetski


