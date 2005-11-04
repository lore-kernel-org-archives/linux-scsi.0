From: "Ju, Seokmann" <Seokmann.Ju@engenio.com>
Subject: RE: Problems getting linux-2.4.31 to detect logical drive on mega
	raid ATA card.
Date: Fri, 4 Nov 2005 12:36:56 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662C0C@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:26816 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750755AbVKDRhQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2005 12:37:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Matthew Schumacher' <matt.s@aptalaska.net>, linux-scsi@vger.kernel.org

On Friday, November 04, 2005 4:05 AM, Matthew Schumacher wrote:
> At this point I'm not sure what to do.  Any ideas on how to make the
> newer megaraid driver see the logical drive?
I assume you are using DELL system.
Can you provide detail system configuration (like, # of CPU and speed, size
of memory, MegaRAID ATA controller model, etc)?

It seems like the kernel (or the driver) is NOT detecting the device for
some reason. We will post update as we make.

Thank you,

> -----Original Message-----
> From: Matthew Schumacher [mailto:matt.s@aptalaska.net] 
> Sent: Friday, November 04, 2005 4:05 AM
> To: linux-scsi@vger.kernel.org
> Subject: Problems getting linux-2.4.31 to detect logical 
> drive on megaraid ATA card.
> 
> List,
> 
> I have a problem I just can't seem to figure out. linux 2.4.27 can see
> the logical drive just fine:
> 
> megaraid: v2.10.3 (Release Date: Thu Apr  8 16:16:05 EDT 2004)
> megaraid: found 0x101e:0x1960:bus 0:slot 3:func 0
> scsi0:Found MegaRAID controller at 0xf89c3000, IRQ:17
> megaraid: [6.62:1.03] detected 1 logical drives.
> megaraid: supports extended CDBs.
> megaraid: channel[0] is raid.
> megaraid: channel[1] is raid.
> megaraid: channel[2] is raid.
> megaraid: channel[3] is raid.
> scsi0 : LSI Logic MegaRAID 6.62 254 commands 16 targs 7 chans 7 luns
> scsi0: scanning scsi channel 0 for logical drives.
>   Vendor: MegaRAID  Model: LD 0 RAID1  114G  Rev: 6.62
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> scsi0: scanning scsi channel 1 for logical drives.
> scsi0: scanning scsi channel 2 for logical drives.
> scsi0: scanning scsi channel 4 [P0] for physical devices.
> scsi0: scanning scsi channel 5 [P1] for physical devices.
> scsi0: scanning scsi channel 6 [P2] for physical devices.
> scsi0: scanning scsi channel 7 [P3] for physical devices.
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> SCSI device sda: 234348544 512-byte hdwr sectors (119986 MB)
> Partition check:
>  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 >
> usb.c: registered new driver usbdevfs
> 
> However linux-2.4.31 doesn't see it:
> 
> SCSI subsystem driver Revision: 1.00
> megaraid: v2.10.8.2 (Release Date: Mon Jul 26 12:15:51 EDT 2004)
> megaraid: found 0x101e:0x1960:bus 0:slot 3:func 0
> scsi0:Found MegaRAID controller at 0xf8855000, IRQ:15
> megaraid: [6.62:1.03] detected 1 logical drives.
> megaraid: supports extended CDBs.
> megaraid: channel[0] is raid.
> megaraid: channel[1] is raid.
> megaraid: channel[2] is raid.
> megaraid: channel[3] is raid.
> scsi0 : LSI Logic MegaRAID 6.62 254 commands 16 targs 7 chans 7 luns
> scsi0: scanning scsi channel 0 for logical drives.
> scsi0: scanning scsi channel 1 for logical drives.
> scsi0: scanning scsi channel 2 for logical drives.
> scsi0: scanning scsi channel 3 for logical drives.
> scsi0: scanning scsi channel 4 [P0] for physical devices.
> scsi0: scanning scsi channel 5 [P1] for physical devices.
> scsi0: scanning scsi channel 6 [P2] for physical devices.
> scsi0: scanning scsi channel 7 [P3] for physical devices.
> 
> The card is a LSI ATA megaraid controller sold by dell as a CERT card.
> I have the latest firmware on it.
> 
> At this point I'm not sure what to do.  Any ideas on how to make the
> newer megaraid driver see the logical drive?
> 
> schu
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
