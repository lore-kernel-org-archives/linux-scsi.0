From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 07 Aug 2007 11:24:47 -0400
Message-ID: <46B88EBF.3010903@garzik.org>
References: <1186248703.3439.20.camel@localhost.localdomain>	<alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>	<1186458941.6637.44.camel@localhost.localdomain> <20070807001429.f8cb3b22.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39114 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbXHGPYu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2007 11:24:50 -0400
In-Reply-To: <20070807001429.f8cb3b22.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Andrew Morton wrote:
> On Mon, 06 Aug 2007 22:55:41 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:
>> I really, *really* think we need a pre-release tree that consists of all
>> the upstream targetted features (i.e. all of the for the next merge
>> window git trees) and nothing else.
> 
> That *is* -mm.  The vast majority of -mm is the 75-odd subsystem trees. 

Not quite.

-mm is git trees plus an amazing amount of random patches that turned up 
on LKML, a lot of which is not destined for kernel release 2.6.(X+1) or 
2.6.(X+2),


> Plus, an *amazing* amount of stuff turns up in the git trees which was
> committed just a few days prior to the merge window opening, or even after
> it opening.

Yes :(  That's a tough problem to solve, too.

Deadlines always motivate people, and so -- as in almost every other 
software project I've worked with -- everybody seems to submit their 
work on the day of the deadline.

Realistically, for the merge window to work perfectly, each step down 
the maintainership ladder needs to have time to review and integrate the 
changes destined for that merge window.  Ideally, people would do all 
this work beforehand, so that each step up the ladder has time prior to 
merge window for review and testing.

But that's just not software engineers as we know them ;-)


>>  The lack of a tree like this that we could have
>> persuaded people to test for the last month is what's causing us to
>> scramble like this at the closure of the merge window.
> 
> Nope.  The scramble is caused by subsystem maintainers jamming stuff into
> mainline at the last minute so they don't have to sit on it for the next
> two months.

Indeed.  Particularly in this case, where bsg didn't really grace -mm at 
all.


> Look.  If we're serious about this then the rule needs to be something like
> 
>   If it wasn't committed to your tree *at least* two weeks prior to the
>   2.6.x merge window opening, it shouldn't go into 2.6.x.
> 
> People are not presently observing this sort of discipline by a metric
> mile.  And I'm not sure that we should, really.

My goal AT A MINIMUM with netdev and libata is to get stuff in at least 
one -mm release prior to merge window opening (though preferably a 
longer lead time than that).  Of course, reality intrudes, but that's my 
goal.

And I think it's a reasonable goal to push upon others (but I'm biased:))

	Jeff


