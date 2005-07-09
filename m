From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 9 Jul 2005 12:27:12 -0400
Message-ID: <20050709162712.GB27347@phunnypharm.org>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:15840 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261588AbVGIQ1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 12:27:13 -0400
Content-Disposition: inline
In-Reply-To: <1120922306.5008.5.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

If it was orphaned it was done so mistakenly. I maintain that code, and
linux1394.

Aside from that, the the change was pushed into the mainstream kernel
without going through our repository, which means it would have been
caught before going to all of our users (most of users of ieee1394 on
linux use it for sbp2).

THese changes break sbp2, and we'll need to revert them in the main stream
kernel until the patch is tested and fixed in our tree.


On Sat, Jul 09, 2005 at 10:18:26AM -0500, James Bottomley wrote:
> On Sat, 2005-07-09 at 14:37 +0200, Stefan Richter wrote:
> > there are a few changes to sbp2 in linux-2.6.13 (-rc2) that were not
> > merged back into the linux1394.org repository (and were not tested by
> > linux1394 maintainers as far as I have heard). Most of these changes
> > deal with TYPE_RBC devices.
> 
> That's probably because no-one knows about you: the sbp2 driver is
> listed as Orphaned in the MAINTAINERS file.  You're welcome to take over
> maintenance, but you need to get that file updated.
> 
> > I have one question for now: Is the following part of the diff related
> > to the TYPE_RBC issue, or is it unrelated? As you can see, locking is
> > removed from sbp2scsi_complete_command() but added to sbp2scsi_reset():
> 
> It's from the SCSI reset API changes, as a quick excursion into the
> kernel web history viewer would have shown you:
> 
> http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;h=a92b7b80579fe68fe229892815c750f6652eb6a9;f=drivers/ieee1394/sbp2.c
> 
> James
> 
> 
> 
> 
> 
> 
> -------------------------------------------------------
> This SF.Net email is sponsored by the 'Do More With Dual!' webinar happening
> July 14 at 8am PDT/11am EDT. We invite you to explore the latest in dual
> core and dual graphics technology at this free one hour event hosted by HP,
> AMD, and NVIDIA.  To register visit http://www.hp.com/go/dualwebinar
> _______________________________________________
> mailing list linux1394-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux1394-devel

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
