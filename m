From: "Kai Ruhnau" <kai@tragetaschen.dyndns.org>
Subject: Re: Driver for Adaptec AHA-1530P
Date: Sun, 11 Jan 2004 01:33:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0cb401c3d7da$7f695e00$060ba8c0@AldiP4>
References: <Pine.LNX.4.44.0401102219130.6033-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout05.sul.t-online.com ([194.25.134.82]:19145 "EHLO
	mailout05.sul.t-online.com") by vger.kernel.org with ESMTP
	id S265693AbUAKAdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2004 19:33:46 -0500
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Sat, 10 Jan 2004, Kai Ruhnau wrote:
>
> > The kernel 2.4.10 is from a SuSE-Linux 7.3 boot-disk with the aha152x as
> > module.
> >
> > Here is the log after I loaded the module:
>
> Hm, it might also be, that your problem comes not from changes in the
> driver, but from switching from module to compiled-in. Can you try either
> 2.4.10 with driver compiled-in or 2.4.2x with driver as a module (also
> with a diskette or initrd)?

My Post:

> I retract having a working 2.4.10 in the following sense:
>
> I have a precompiled kernel 2.4.10 from SuSE-Linux 7.3. It worked before,
> but I decided to install Gentoo as my new Linux-distribution. Now 2.4.10
is
> only left on a boot disk set.
> I can load the module for aha152x from these bootdisks and it works.

This precompiled kernel is with aha152x as a module.

> But I just tried to use a self-compiled 2.4.10 from the kernel.org sources
> and it fails.
> After "scsi0 : Adaptec 152x SCSI driver; $Revision: 2.4 $" I get a timeout
> and a NULL-pointer dereference.

This one is with aha152x compiled in.

Greetings
Kai

> ----- Original Message ----- 
> From: "Kai Ruhnau" <kai@tragetaschen.dyndns.org>
> To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
> Cc: <linux-scsi@vger.kernel.org>
> Sent: Saturday, January 10, 2004 4:03 PM
> Subject: Re: Driver for Adaptec AHA-1530P
>
>
> > Hi,
> >
> > Thank you for the quick reply!
> >
> > > Can you send the relevant lines from 2.4.10 boot?
> >
> > The kernel 2.4.10 is from a SuSE-Linux 7.3 boot-disk with the aha152x as
> > module.
> >
> > Here is the log after I loaded the module:
> >
> > <snip>
> > [...]
> > [isapnp]
> > aha152x: BIOS test: passed, auto configuration: ok, detected 1
> controller(s)
> > aha152x: resetting bus...
> > aha152x0: vital data: rev=1, io=0x340 (0x340/0x340), irq=11, scsiid=7,
> > reconnect=enabled, parity=enabled, synchronous=enabled, delay=1000,
> extended
> > translation=disabled
> > aha152x0: trying software interrupt, ok.
> > scsi0 : Adaptec 152x SCSI driver; $Revision: 2.4 $
> > (scsi0:0:0) 01 03 01 32 08 00
> >   Vendor: IBM       Model: DCAS-34330        Rev: S65A
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > [my cdrom @ scsi0:5:0]
> > [...]
> > </snip>
> >
> > HTH
> > Greetings
> > Kai
> >
> > ----- Original Message ----- 
> > From: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
> > To: "Kai Ruhnau" <kai@tragetaschen.dyndns.org>
> > Cc: <linux-scsi@vger.kernel.org>
> > Sent: Saturday, January 10, 2004 1:48 PM
> > Subject: Re: Driver for Adaptec AHA-1530P
> >
> >
> > > Hi
> > >
> > > Can you send the relevant lines from 2.4.10 boot?
> > >
> > > Cheers
> > > Guennadi
> > >
> > > On Sat, 10 Jan 2004, Kai Ruhnau wrote:
> > >
> > > > Hi,
> > > >
> > > > I have an old scsi-only P200. It has an Adaptec AHA-1530P ISA-board.
> > > >
> > > > I had and have a running Kernel 2.4.10. It uses the driver aha152x
> > > > successfully. I tried to update to 2.4.16, 2.4.20 and now I try
> 2.4.24.
> > All
> > > > show the same behaviour:
> > > >
> > > > Kernel-parameter: 'aha152x=0x340'
> > > >
> > > > <snip>
> > > > SCSI subsystem driver Revision: 1.00
> > > > aha152x: processing commandline: <3>
> > > > aha152x: 0x340
> > > > aha152x: Invalid line
> > > > ok
> > > > aha152x: BIOS test: passed, detected 1 controller(s)
> > > > aha152x: resetting bus...
> > > > aha152x0: vital data: rev=7, io=0x340 (0x340/0x340), irq=11,
scsiid=7,
> > > > reconnect=enabled, parity=enabled, synchronous=enabled, delay=1000,
> > extended
> > > > translation=disabled
> > > > aha152x0: trying software interrupt, ok.
> > > > scsi0 : Adaptec 152x SCSI driver; $Revision: 2.5 $
> > > > (long pause)
> > > > aha152x: ABORT timed out - removed from issue queue
> > > > scsi: device set offline - not ready or command retry failed after
bus
> > > > reset: host 0 channel 0 id 0 lun 0
> > > > scsi: unknown type 22
> > > > Vendor: [crap] Model: [more crap] Rev:
> > > > Type: Unknown
> > > > (again long pause)
> > > > </snip>
> > > >
> > > > And the last seven lines count up the lun and the id up to 'id 7 lun
> 7'.
> > > > After that, I end up with a kernel-panic due to the missing
> root-device.
> > > > The [crap] and [more crap] are always the same characters.
> > > >
> > > > In kernel 2.6.0 the aha152x-driver does not find any appropiate
> device.
> > Here
> > > > I also tried the aha1542, but I can't read any error, it scrolls up
> too
> > > > fast.
> > > >
> > > >
> > > > I know from the Changelogs that there were a couple of changes since
> > 2.4.10,
> > > > but is it possible to convince the aha152x (or any other) driver to
> work
> > > > with my card?
> > > >
> > > > Of course I'm willing to help everybody as I can.
> > > >
> > > > Greetings
> > > > Kai
> > > >
> > > > -
> > > > To unsubscribe from this list: send the line "unsubscribe
linux-scsi"
> in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >
> > > >
> > >
> > > ---
> > > Guennadi Liakhovetski
> > >
> > >
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

