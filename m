From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [usb-storage] Re: External USB3 disk fails with "Invalid field
 in cdb"
Date: Mon, 30 Jun 2014 07:12:42 -0700
Message-ID: <1404137562.2994.0.camel@jarvis.lan>
References: <Pine.LNX.4.44L0.1406271521350.875-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45825 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbaF3OMo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jun 2014 10:12:44 -0400
In-Reply-To: <Pine.LNX.4.44L0.1406271521350.875-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>, "Bryn M. Reeves" <bmr@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Fri, 2014-06-27 at 15:23 -0400, Alan Stern wrote:
> On Fri, 27 Jun 2014, Michael B=C3=BCsch wrote:
>=20
> > On Fri, 27 Jun 2014 14:42:01 -0400 (EDT)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> >=20
> > > Michael, can you post the "lsusb -v" output for this device?  I s=
ee it=20
> > > is made by JMicron; they are notorious for buggy USB-ATA bridges.
> >=20
> > Of course. Here you go:
> >=20
> > Bus 004 Device 009: ID 152d:0567 JMicron Technology Corp. / JMicron=
 USA Technology Corp.=20
> > Device Descriptor:
> >   bLength                18
> >   bDescriptorType         1
> >   bcdUSB               3.00
> >   bDeviceClass            0 (Defined at Interface level)
> >   bDeviceSubClass         0=20
> >   bDeviceProtocol         0=20
> >   bMaxPacketSize0         9
> >   idVendor           0x152d JMicron Technology Corp. / JMicron USA =
Technology Corp.
> >   idProduct          0x0567=20
> >   bcdDevice            1.14
> >   iManufacturer           1 JMicron
> >   iProduct                2 USB to ATA/ATAPI Bridge
> >   iSerial                 3 xxx
> >   bNumConfigurations      1
> >   Configuration Descriptor:
> >     bLength                 9
> >     bDescriptorType         2
> >     wTotalLength          121
> >     bNumInterfaces          1
> >     bConfigurationValue     1
> >     iConfiguration          4 USB Mass Storage
> >     bmAttributes         0xc0
> >       Self Powered
> >     MaxPower                2mA
> ...
>=20
> > MaxPower=3D2mA is a nice guess for a hard disk. ;)
>=20
> That refers to the amount of power the device draws from the USB bus.=
 =20
> Since the disk drive is self-powered, it doesn't use much bus power.
>=20
> Does the patch below do what you and James want?

Yes, that's the usual annoying additions to our blacklist.  You can add
my acked-by and could you cc stable?

Thanks,

James



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
