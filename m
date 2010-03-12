From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PULL] final scsi updates for 2.6.34-rc1
Date: Fri, 12 Mar 2010 12:27:21 -0600
Message-ID: <1268418441.2802.61.camel@mulgrave.site>
References: <1268242604.22601.25.camel@mulgrave.site>
	 <alpine.LFD.2.00.1003121008420.3719@i5.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1003121008420.3719@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-03-12 at 10:10 -0800, Linus Torvalds wrote:
> 
> On Wed, 10 Mar 2010, James Bottomley wrote:
> >
> > OK, I know this is a bit late, but no-one told me the merge window was
> > going to close early, but even if they had I'd have been unable to do
> > anything about it, since I've been in transit from India all this week
> > so far (don't ask ...).
> 
> I'm not going to pull.
> 
> The whole "a few days early" was literally aimed at you and some similar 
> people who _always_ send the pull request late, literally the last days.
> 
> I'm fed up with it.
> 
> The damn thing should have been ready when the merge window _opened_, not 
> just before closing. And now there _is_ a tree waiting for me for the next 
> merge window. Goodie.

I do always have a tree ready in the first days of the merge window.  It
was, in fact, here:

commit 654451748b779b28077d9058442d0f354251870d
Merge: 64d497f 77c9cfc
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Feb 26 16:55:27 2010 -0800

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6

The slight problem is that I accumulate updates (like almost everyone
else) from the few days before the merge window opened up until about
the middle of the second week.  That's what goes into the final pull,
plus assorted bug fixes that showed up during the window.

I'm not objecting to a shorter merge window, just the unpredictability
of all of this.  The reason I delay the second pull until the last days
of the merge window is so that the proposed changes get the maximum
amount of shake down in linux-next ... and that usually means I close
down the inclusion window about three days before the pull request goes
out.

Personally, I do like the two week merge window, because it shakes out
contributors to me who should have got their act together but didn't.
If you don't like the way this works, fine ... I just need to know what
the parameters are to adjust accordingly, so what is it now?  A 10 day
merge window?

James
