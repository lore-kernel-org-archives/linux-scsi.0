From: "Nicholas Berry" <nikberry@med.umich.edu>
Subject: Re: Adaptec 2940 Host controller
Date: Wed, 03 Jul 2002 08:04:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <sd22b00b.080@mail-02.med.umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: TaylorNE@logica.com, linux-scsi@vger.kernel.org



> >>> "Taylor, Neville" <TaylorNE@logica.com> 07/03/02 07:09AM >>>
>
> I'm trying to install a Adaptec 2940 host adapter.
>
> When I do "modprobe aic7xxx" I get
>
> /lib/modules/2.4.18-3/kernel/drivers/scsi/aic7xxx/aic7xxx.o: init_module: No
> such device
>
> /lib/modules/2.4.18-3/kernel/drivers/scsi/aic7xxx/aic7xxx.o: insmod
> /lib/modules/2.4.18-3/kernel/drivers/scsi/aic7xxx/aic7xxx.o failed
>
> /lib/modules/2.4.18-3/kernel/drivers/scsi/aic7xxx/aic7xxx.o: insmod aic7xxx
> failed
> 
> This looks to me like the system can't see the card but  m /proc/pci file
> has an entry that looks like
> 
> Bus 0, device 8, function 0:
> Class ffff: Adaptec AHA-294x / AIC- 7871 ( rev 255)
>     IRQ 11
>     Master Capable. Latency=255. Min Gnt=255.Max Lat=255

Rev 255, Latency 255, Min Gnt 255, Max Lat 255. Hmm. They look very suspicious numbers to me!

I think the controller's bad.

Nik

>     I/O at 0xfc00 [0xfcff]
>     Non-prefetchable 32 bit memory at 0x3efff000 [0x3effffff]
>
> which implies it can see the card.



