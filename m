From: "Taylor, Neville" <TaylorNE@logica.com>
Subject: RE: Adaptec 2940 Host controller
Date: Wed, 3 Jul 2002 13:10:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <ABDA876D71F9D211B39D0090274EA8E20BC913E5@Floyd.logica.co.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Nicholas Berry' <nikberry@med.umich.edu>, "Taylor, Neville" <TaylorNE@logica.com>, linux-scsi@vger.kernel.org



-----Original Message-----
From: Nicholas Berry [mailto:nikberry@med.umich.edu]
Sent: 03 July 2002 13:04
To: TaylorNE@logica.com; linux-scsi@vger.kernel.org
Subject: Re: Adaptec 2940 Host controller


I did wonder myself but I've previously had the same setup working with a
Microsoft (Please don't hate me!!) Win2k machine.


> >>> "Taylor, Neville" <TaylorNE@logica.com> 07/03/02 07:09AM >>>
>
> I'm trying to install a Adaptec 2940 host adapter.
>
> When I do "modprobe aic7xxx" I get
>
> /lib/modules/2.4.18-3/kernel/drivers/scsi/aic7xxx/aic7xxx.o: init_module:
No
> such device
>
> /lib/modules/2.4.18-3/kernel/drivers/scsi/aic7xxx/aic7xxx.o: insmod
> /lib/modules/2.4.18-3/kernel/drivers/scsi/aic7xxx/aic7xxx.o failed
>
> /lib/modules/2.4.18-3/kernel/drivers/scsi/aic7xxx/aic7xxx.o: insmod
aic7xxx
> failed
> 
> This looks to me like the system can't see the card but  m /proc/pci file
> has an entry that looks like
> 
> Bus 0, device 8, function 0:
> Class ffff: Adaptec AHA-294x / AIC- 7871 ( rev 255)
>     IRQ 11
>     Master Capable. Latency=255. Min Gnt=255.Max Lat=255

Rev 255, Latency 255, Min Gnt 255, Max Lat 255. Hmm. They look very
suspicious numbers to me!

I think the controller's bad.

Nik

>     I/O at 0xfc00 [0xfcff]
>     Non-prefetchable 32 bit memory at 0x3efff000 [0x3effffff]
>
> which implies it can see the card.



This e-mail and any attachment is for authorised use by the intended recipient(s) only.  It may contain proprietary material, confidential information and/or be subject to legal privilege.  It should not be copied, disclosed to, retained or used by, any other party.  If you are not an intended recipient then please promptly delete this e-mail and any attachment and all copies and inform the sender.  Thank you.
