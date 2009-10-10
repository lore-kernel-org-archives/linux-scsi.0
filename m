From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
Date: Sat, 10 Oct 2009 13:18:17 -0600
Message-ID: <200910101318.17785.tfjellstrom@shaw.ca>
References: <200910091141.52303.tfjellstrom@shaw.ca> <200910100956.19241.tfjellstrom@shaw.ca> <20091010164422.GA8896@linux-dev>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:7877 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762051AbZJJTTD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Oct 2009 15:19:03 -0400
In-Reply-To: <20091010164422.GA8896@linux-dev>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ying Chu <gm.ychu@gmail.com>
Cc: ayan@marvell.com, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat October 10 2009, Ying Chu wrote:
> Hi, Thomas
> 
>  Did you build the dm/md storage with SATA disk drives?

Yes I did. I've got 5 Seagate 7200.12 1TB disks, and two 2TB WD Green drives. 
The last two tests used solely the 5 Seagates though.

> On Sat, Oct 10, 2009 at 09:56:19AM -0600, Thomas Fjellstrom wrote:
> > From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
> > To: linux-kernel <linux-kernel@vger.kernel.org>
> > Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
> > Date: Sat, 10 Oct 2009 09:56:19 -0600
> > Cc: linux-raid <linux-raid@vger.kernel.org>,
> > 	linux-scsi <linux-scsi@vger.kernel.org>
> > X-Mailing-List: linux-scsi@vger.kernel.org
> >
> > On Fri October 9 2009, Thomas Fjellstrom wrote:
> > > Hi,
> > >
> > > I've been trying to get an AOC-SASLP-MV8 card (pcie x4 2 port SAS card)
> > > to work with linux for the past month or so. I've recently just RMAed
> > > my first card, and tested the new one under linux, and I see the same
> > > problems.
> > >
> > > The very first time I made a new array off the controller, formated
> > > (with xfs) and mounted the volume, it seemed to work. ioozone even
> > > seemed to run for a while. Sadly after a few minutes I got a stream of
> > > mvs_abort_task messages in dmesg, and any accesses to the volume, or
> > > any disks connected to the controller lock up.
> > >
> > > After that I updated my 2.6.31 kernel to 2.6.32-rc3-git2 off of
> > > kernel.org, and the volume fails to mount with the same mvs_abort_task
> > > messages.
> > >
> > > I've attached my dmesg log from both attempts. dmesg1 is the first
> > > attempt, dmesg2 is the second attempt on the newer kernel.
> > >
> > > I would really appreciate some help with this.
> >
> > I should also mention that if I attempt to remove any of the drives while
> > the card is in a hung state, the entire machine locks up with the
> > keyboard LEDs blinking.
> >
> > This does seem to be a rather serious error.
> >
> > If there is more I can do to help track down the problems, please let me
> > know. I really need to get this to work (my current array is FULL, and
> > may be showing signs of failure) as soon as possible.
> >
> > I can pretty much wipe and reinstall everything at any point on this
> > machine, update/install new kernels, etc. I just don't have a null modem
> > cable atm to hook up a serial console to capture the errors on OOPSes.
> >
> > Thanks.
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
