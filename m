From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Can't eject jaz disk on 2.6
Date: Sat, 27 Mar 2004 19:07:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040327190746.A4500@animx.eu.org>
References: <20040327075918.A2232@animx.eu.org> <20040327224222.GA5203@one-eyed-alien.net> <20040327180018.A4269@animx.eu.org> <20040327225258.GB5203@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dial249.pm3abing3.abingdonpm.naxs.com ([216.98.75.249]:16001
	"EHLO animx.eu.org") by vger.kernel.org with ESMTP id S261943AbUC0X44
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Mar 2004 18:56:56 -0500
In-Reply-To: <20040327225258.GB5203@one-eyed-alien.net>; from Matthew Dharm on Sat, Mar 27, 2004 at 02:52:58PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>

Keep me in CC, I removed linux-kernel list, I'm not on the other 2.

> > > > I've used 2.6.0 to 2.6.4 on a computer with a jaz drive.
> > > > Using eject 2.0.13, I'm unable to eject the disk.  I have tested on 2.4.24
> > > > and it does eject.
> > > 
> > > Over on the usb-storage list, we've just become aware of a similar problem.
> > 
> > What was it with?
> 
> The device in question there was an Iomega USB Zip 100 drive.

I see.

> > > Are you using SCSI or IDE?
> > 
> > SCSI.  I thought all JAZ disks were scsi?
> 
> I wasn't sure.  USB is emulated through the SCSI layer, tho.  I would
> recommend we take this discussion to the linux-scsi mailing list.

IIRC all JAZ drivers were scsi.  Looks like they no longer make the jaz
drive.

> > > We've actually recorded the SCSI layer sending us a PREVENT_MEDIUM_REMOVAL,
> > > then a START_STOP (to actually eject), and then an ALLOW_MEDIUM_REMOVAL.
> > > So, nothing gets ejected.  This is under 2.6.
> > 
> > I have noticed that when I attempt to eject, it spins the disk backup,
> > spins down and that's it.
> 
> The user of the Zip 100 actually sent us logs showing this behavior.  We
> assume it's coming from the SCSI system, as usb-storage doesn't contain
> anything remotely resembling this....
> 
> Repeated uses of the 'eject' command generated the same sequence in his
> test scenario, but his Zip 100 actually ejected the media on the second
> try.  I think that's a device-dependent behavior, tho.

Didn't for me, but I only ran eject 2 times.  I did not want to add
unnecessary wear on the motor since it spins up and back down.  I'm sure it
is with scsi, but I don't have a zip drive.  (Didn't see the need, 100mb is
nothing nowadays)

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
