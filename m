From: jklaas <jklaas@comcast.net>
Subject: Re: firmware help
Date: Fri, 10 Sep 2004 12:50:58 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0409101236210.27903@shenandoah>
References: <Pine.LNX.4.58.0409081347100.27903@shenandoah>
 <311601c9040910092061681de5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc13.comcast.net ([204.127.202.64]:15063 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S267543AbUIJQur (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 12:50:47 -0400
In-Reply-To: <311601c9040910092061681de5@mail.gmail.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


On Fri, 10 Sep 2004, Eric Mudama wrote:

> On Wed, 8 Sep 2004 14:51:42 -0400 (EDT), jklaas <jklaas@comcast.net> wrote:
> > From everything I've read about firmware on SCSI drives, it appears to be
> > impossible to extract the firmware from a drive.  I was hoping that there
> > was some sort of SCSI programming judo to make this drive divulge this
> > information.  Would I be better off trying to extract the firmware
> > directly from the flash chip somehow?
> >
> > I was hoping to find some firmware for some EMC Symmetrix/Seagate drives.
> > These are Elite 47 drives labelled with Seagate model #ST446452W, and
> > a "non-Seagate" part number 9K7001-021.  These drives were apparently only
> > ever sold to EMC and were designed by Seagate for EMC specifically.  (Is
> > this true of all the Elite drives?)
> >
> > Seagate said "The part number you provided for us indicates that the drive
> > is OEM.  Please contact your vendor to receive the proper firmware
> > upgrade."  Unfortunately, EMCs support site is impenetrable.
> >
> > Thank you for your help.
>
> I'm sure there is hidden judo to extract that data, but those who know
> it aren't allowed to reveal it because we either 1) work for a drive
> manufacturer and would get fired or 2) work for a data recovery
> company and make our living with that judo.
>
> What exactly do you hope to accomplish with a binary firmware image
> anyway?  The firmware is liable to be a binary image from a custom
> architecture... which'd be a LOT of work to try to decode into
> something meaningful...
>
> --eric
>

Well, the problem is that I have a bunch of disks (ST446452W) with one
firmware version (B407) that doesn't seem to report data correctly to my
RAID card (MegaRAID 438/Enterprise 1400, Firmware GH8E, BIOS 1.48) and
otherwise don't respond to that RAID card.  However, one disk that has a
different firmware version (B410) does seem to report correctly to the
RAID card and does appear to work correctly.  It appears to be impossible
to locate a firmware file for these disks, so I was just hoping there was
some way to create one from the disk that does work.

I'll probably be working on another way around this (i.e. a different
RAID card or back-rev the firmware on the MegaRAID 438).

Thanks again for your help.

			James Klaas

Procrastinate NOW!!!! -- Don't put it off.


