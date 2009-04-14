From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: LSF Papers online?
Date: Tue, 14 Apr 2009 16:54:23 +0200
Message-ID: <200904141654.24067.bzolnier@gmail.com>
References: <49E335BA.3020103@panasas.com> <200904140324.59657.bzolnier@gmail.com> <49E461E8.10106@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56453 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbZDNOvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 10:51:24 -0400
In-Reply-To: <49E461E8.10106@garzik.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux IDE mailing list <linux-ide@vger.kernel.org>

On Tuesday 14 April 2009 12:14:00 Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 14 April 2009 00:24:57 Jeff Garzik wrote:
> >> Bartlomiej Zolnierkiewicz wrote:
> >>> I've started reading it and immediately noticed a thing which made by day. :-)
> >>>
> >>> Sorry if it will sound off-topic or undiplomatic but it is the best occasion
> >>> to straighten up some facts:
> >>>
> >>>  "Discussion then moved on to the current status of getting libata out of
> >>>   SCSI: we have had several successes, notably timer handling and pieces of
> >>>   error handling have moved up to block. Unfortunately, the current progress
> >>>   has reached the point where it's being impeded by the legacy IDE subsystem
> >>>
> >>> Heh, you can also blame the lack of world peace on the legacy IDE subsystem.
> >>>
> >>> I wonder who came up with this ridiculous excuse (I'm sure it wasn't James!).
> > 
> > It was you!? :)
> > 
> >>> The thing is that during last _five_ years almost nothing was done in this
> >>> direction.  Despite the fact that it was #1 condition under which the whole
> >>> code has been merged.  Sorry to say it but it seems like the whole merge
> >>> strategy was to over-promise things now and worry about delivery later.
> >> Yet, shockingly, users have been happily using libata despite all these 
> >> horrors.
> > 
> > That was not the issue raised:
> > 
> > If you think that you can take a "I will deliver later" credit from the
> > developers community and later cover it up by "this is still my goal, I
> > just need to find some suckers to do it for me" and think that you won by
> > fooling people you're sadly mistaken and will most likely have a reality
> > check one day (not from me, I really don't care that much to waste my
> > precious time on proving you wrong).
> 
> The project you refer to -- move libata out of SCSI -- is far less 
> important than another project:  keep libata going amidst new SAS and 
> SATA hardware.
> 
> Choosing to use the SCSI driver infrastructure was a solid technical 
> decision in the beginning, and time has proven that true:  since we were 
> inside SCSI, ATAPI and SAT support came naturally.  Support for SAS+SATA 
> controllers came naturally.
> 
> So it was absolutely the right thing to do for Linux users, to 
> de-prioritize the libata-out-of-SCSI project.

You made this decision yourself without consulting it with anybody.

> The users were not, and are not, asking for it.  It will even introduce 
> some breakage if you're not careful.

The users were not asking for many other things, i.e. libata PATA.

> The only people who even mention it are a few key IDE and block layer 
> developers - me, you, Tejun, Jens, sometimes James B.  Linus has 
> probably forgotten, but for I occasionally mention it at kernel summits.

Did you you forget about Intel guys and other people working on SSDs?

> I think Linux users are happy that they were delivered a working ATA 
> driver of a much more clean design.  That is the delivery that matters.

It was clean design in 2003.

Now it is yet another fairly complex piece of code.

i.e. please go into libata-eh.c, try to make sense out of it and track all
subtle libata-SCSI-block interactions (yes, the code is clean by mingo's
cleanness standard -- this is not the point here)

To keep the design clean and modern the constant _significant_ maintenance
work is needed.

I also don't buy this "That is the delivery that matters" mantra repeated
by some people.  Agreed delivery is the most important thing but how you get
there is also very important in the longer-term.

> Even with the benefit of hindsight, I don't see that libata development 
> should have happened any other way.

How's about starting with working on the existing ATA/IDE subsystem?

You lacked _any_ hands-on experience with it.

You were given green light on libata simply because we had no other choice:
you came up with the full solution without any previous discussions and used
the same "think about users" excuse.

The SATA features that needed SCSI infrastructure came 2 years later.

> Moving libata out of SCSI is now a long term, far off goal.  A goal that 
> implies many intermediate steps, cleanups to block, libata, IDE, SCSI 
> and other block drivers.

"far off"?

The fact that it is much harder to do nowadays than in 2004-2005 (without
ATAPI support, PATA support and heavy dependence on SCSI infrastructure)
is only _your_ fault.

> I am highly confident we will reach this goal eventually, but there is 
> no rush.  If it takes ten years, fine.  THIS IS THE PROCESS.  The end 
> result will be that all storage drivers in the kernel are improved.

"eventually"?

"no rush"?

"ten years"?

I don't have that much patience left.

> We steer this ship by having a general idea of where we want to go, not 
> a specific roadmap.  Interesting, unexpected things happen during the 
> journey, perhaps taking you down a different course.  Open source... 
> it's all very zen.  :)

Please save us the management fairy-tales and just show us the code.

Thanks,
Bart
