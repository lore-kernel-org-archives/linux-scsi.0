From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] final scsi updates for 2.6.34-rc1
Date: Fri, 12 Mar 2010 10:40:50 -0800 (PST)
Message-ID: <alpine.LFD.2.00.1003121035490.3719@i5.linux-foundation.org>
References: <1268242604.22601.25.camel@mulgrave.site>  <alpine.LFD.2.00.1003121008420.3719@i5.linux-foundation.org> <1268418441.2802.61.camel@mulgrave.site> <alpine.LFD.2.00.1003121028390.3719@i5.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1003121028390.3719@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Fri, 12 Mar 2010, Linus Torvalds wrote:
> 
> And the fact that you complain about the very fact that you were gaming 
> the system and now you can't because it's not predictable enough to game 
> is what just proves my f*cking point!

Btw, just to clarify for next time: I'm not even going to mention in the 
release notes how long the merge window is going to be.

Maybe I'll say "that's enough" after just one week, because the good 
people did what they do, and sent me a lot of merges early, there were no 
problems, and I might as well cut an -rc1 early since I have enough and 
I'd like to occasionally get a _shorter_ release cycle not just because 
the merge window was shorter, but because hopefully merging less might 
result in an easier stabilization cycle too.

Or maybe I'll be busy for a few days, and extend it past the two weeks 
just because I was in the middle of another flame war and needed a few 
extra days to catch up with real work.

Who knows? The point being that being predictable has caused problems. 
People have decided that they have an extra two weeks, and that the merge 
window isn't a window at all, it's just a day when -rc1 gets done.

			Linus
