From: Jeff Garzik <jeff@garzik.org>
Subject: Re: LSF Papers online?
Date: Tue, 14 Apr 2009 06:14:00 -0400
Message-ID: <49E461E8.10106@garzik.org>
References: <49E335BA.3020103@panasas.com> <200904132340.21525.bzolnier@gmail.com> <49E3BBB9.4040100@garzik.org> <200904140324.59657.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:48360 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbZDNKOU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2009 06:14:20 -0400
In-Reply-To: <200904140324.59657.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux IDE mailing list <linux-ide@vger.kernel.org>

Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 14 April 2009 00:24:57 Jeff Garzik wrote:
>> Bartlomiej Zolnierkiewicz wrote:
>>> I've started reading it and immediately noticed a thing which made by day. :-)
>>>
>>> Sorry if it will sound off-topic or undiplomatic but it is the best occasion
>>> to straighten up some facts:
>>>
>>>  "Discussion then moved on to the current status of getting libata out of
>>>   SCSI: we have had several successes, notably timer handling and pieces of
>>>   error handling have moved up to block. Unfortunately, the current progress
>>>   has reached the point where it's being impeded by the legacy IDE subsystem
>>>
>>> Heh, you can also blame the lack of world peace on the legacy IDE subsystem.
>>>
>>> I wonder who came up with this ridiculous excuse (I'm sure it wasn't James!).
> 
> It was you!? :)
> 
>>> The thing is that during last _five_ years almost nothing was done in this
>>> direction.  Despite the fact that it was #1 condition under which the whole
>>> code has been merged.  Sorry to say it but it seems like the whole merge
>>> strategy was to over-promise things now and worry about delivery later.
>> Yet, shockingly, users have been happily using libata despite all these 
>> horrors.
> 
> That was not the issue raised:
> 
> If you think that you can take a "I will deliver later" credit from the
> developers community and later cover it up by "this is still my goal, I
> just need to find some suckers to do it for me" and think that you won by
> fooling people you're sadly mistaken and will most likely have a reality
> check one day (not from me, I really don't care that much to waste my
> precious time on proving you wrong).

The project you refer to -- move libata out of SCSI -- is far less 
important than another project:  keep libata going amidst new SAS and 
SATA hardware.

Choosing to use the SCSI driver infrastructure was a solid technical 
decision in the beginning, and time has proven that true:  since we were 
inside SCSI, ATAPI and SAT support came naturally.  Support for SAS+SATA 
controllers came naturally.

So it was absolutely the right thing to do for Linux users, to 
de-prioritize the libata-out-of-SCSI project.

The users were not, and are not, asking for it.  It will even introduce 
some breakage if you're not careful.

The only people who even mention it are a few key IDE and block layer 
developers - me, you, Tejun, Jens, sometimes James B.  Linus has 
probably forgotten, but for I occasionally mention it at kernel summits.

I think Linux users are happy that they were delivered a working ATA 
driver of a much more clean design.  That is the delivery that matters.

Even with the benefit of hindsight, I don't see that libata development 
should have happened any other way.

Moving libata out of SCSI is now a long term, far off goal.  A goal that 
implies many intermediate steps, cleanups to block, libata, IDE, SCSI 
and other block drivers.

I am highly confident we will reach this goal eventually, but there is 
no rush.  If it takes ten years, fine.  THIS IS THE PROCESS.  The end 
result will be that all storage drivers in the kernel are improved.

We steer this ship by having a general idea of where we want to go, not 
a specific roadmap.  Interesting, unexpected things happen during the 
journey, perhaps taking you down a different course.  Open source... 
it's all very zen.  :)

	Jeff


