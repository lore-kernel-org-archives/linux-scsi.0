From: Tom Oehser <tom@toms.net>
Subject: RE: megaraid doesn't detect when bios jumper is off...
Date: Fri, 23 Jul 2004 10:00:38 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407230959350.1703@jupiter.toms.net>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC8A4@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Jupiter.Toms.NET ([64.32.223.162]:61073 "EHLO jupiter.toms.net")
	by vger.kernel.org with ESMTP id S267732AbUGWOAq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2004 10:00:46 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC8A4@EXA-ATLANTA.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org


With the 2.20.1.0 driver it still doesn't find the card...

-Tom

On Thu, 22 Jul 2004, Mukker, Atul wrote:

> Date: Thu, 22 Jul 2004 11:50:09 -0400
> From: "Mukker, Atul" <Atulm@lsil.com>
> To: 'Tom Oehser' <tom@Toms.NET>, "Mukker, Atul" <Atulm@lsil.com>
> Cc: linux-scsi@vger.kernel.org
> Subject: RE: megaraid doesn't detect when bios jumper is off...
>
> Try the 2.10.1.0 driver from
> ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.1.0/
>
> -Atul Mukker
>
> > -----Original Message-----
> > From: Tom Oehser [mailto:tom@Toms.NET]
> > Sent: Thursday, July 22, 2004 11:41 AM
> > To: Mukker, Atul
> > Cc: linux-scsi@vger.kernel.org
> > Subject: RE: megaraid doesn't detect when bios jumper is off...
> >
> >
> >
> > 2.6.7 stock megaraid.c driver. -Tom
> >
> > On Thu, 22 Jul 2004, Mukker, Atul wrote:
> >
> > > Date: Thu, 22 Jul 2004 10:24:35 -0400
> > > From: "Mukker, Atul" <Atulm@lsil.com>
> > > To: 'Tom Oehser' <tom@toms.net>, linux-scsi@vger.kernel.org
> > > Subject: RE: megaraid doesn't detect when bios jumper is off...
> > >
> > > It would be helpful to know the driver and kernel version as well.
> > >
> > > -Atul Mukker
> > >
> > > > -----Original Message-----
> > > > From: Tom Oehser [mailto:tom@toms.net]
> > > > Sent: Wednesday, July 21, 2004 10:36 PM
> > > > To: linux-scsi@vger.kernel.org
> > > > Subject: megaraid doesn't detect when bios jumper is off...
> > > >
> > > >
> > > >
> > > > Hi, I have a MegaRAID SATA 150-6, which is in the same box as a
> > > > Mylex AcceleRaid-250 which is the boot drive.  The motherboard
> > > > doesn't give a way to control boot priority between scsi cards,
> > > > so I set the bios-disable jumper on the MegaRAID card, so that
> > > > it will boot the Mylex, which works fine...
> > > >
> > > > BUT, the MegaRAID driver isn't detecting the MegaRAID when its
> > > > boot bios is disabled!  I can't find a way to get the driver to
> > > > find it and enable it...  And the BIOS setup of the MegaRAID is
> > > > not seeming to have a way to tell it not to try to boot...
> > > >
> > > > So, if I enable the bios jumper on the MegaRAID, it tries to boot
> > > > from it (which fails miserably, as it isn't a boot drive), and if
> > > > I disable the bios jumper on the MegaRAID, it doesn't try to boot
> > > > it, but then the Linux driver doesn't enable it, either!
> > > >
> > > > Help?
> > > >
> > > > -Tom
> > > >
> > > > -
> > > > To unsubscribe from this list: send the line "unsubscribe
> > > > linux-scsi" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >
> > >
> >
>
