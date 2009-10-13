From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Tue, 13 Oct 2009 14:29:37 +0000
Message-ID: <1255444177.2855.91.camel@localhost.localdomain>
References: <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain>
	 <1255031298.4187.260.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain>
	 <20091008210737.GD29181@mit.edu>
	 <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain>
	 <20091009091538.GA4154@elte.hu>
	 <1255097287.2934.21.camel@localhost.localdomain>
	 <20091012130652.GB25464@elte.hu>
	 <1255357148.2850.91.camel@localhost.localdomain>
	 <20091012145453.GD4565@elte.hu>
	 <1255361148.2850.298.camel@localhost.localdomain>
	 <alpine.LFD.2.01.0910121022110.3438@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759994AbZJMOaX@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0910121022110.3438@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>, Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jing Huang <huangj@brocade.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2009-10-12 at 10:24 -0700, Linus Torvalds wrote: 
> 
> On Mon, 12 Oct 2009, James Bottomley wrote:
> > > 
> > > I think you are interpreting what should go into drivers/staging/ _very_ 
> > > narrowly.
> > 
> > As it is my right to do.
> 
> Umm, James, it cuts both ways.
> 
> Others can assert their interpretation, and quite frankly, yours is the 
> odd one out. Everybody else agrees oevrwhelmingly that "staging" is about 
> ugly and not-up-to-snuff drivers.

I haven't actually ever said otherwise.  I have asserted that the bfa
driver, while large, isn't out of the ball park for a FC driver, that it
does provide all the correct user visible FC ABI pieces but that it does
have minor anomalies, primarily in bfa/include, that need cleaning up,
plus it needs to interface to libfc at some future point.  I have also
asserted that drivers/scsi is the best place to address the remaining
issues.

> So you can talk about your 'right' to interpret things all you want, but 
> what's the point? If others haev the same right (which presumably even you 
> agree they do), then if people think a driver is ugly and needs to be in 
> staging, what makes _your_ right so special?

It's a judgement call whether a driver goes through staging or not.  I'm
happy to hear other opinions about this driver, but I'd like them to be
from reading the code, not generalities.  I've stated my specific
reasons why this driver isn't a good candidate for staging.

> As mentioned earlier, I don't personally care about this driver, but I do 
> care about your behavior. You can't just ignore other people if they say 
> that a driver is too damn ugly.

But no-one's actually said that.  The whole discussion was theoretical
rather than based on this driver.  My position on the generalities is
that ABI issues head a driver automatically for staging.  For non user
visible code based issues, it's a maintainer judgement call where the
cleanup is best done, which in turn depends on what the actual issues
are.  For this specific driver, I've given reasons several times why the
changes are best made in drivers/scsi.

James
