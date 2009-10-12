From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Mon, 12 Oct 2009 10:24:51 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0910121022110.3438@localhost.localdomain>
References: <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain>  <1255031298.4187.260.camel@mulgrave.site>  <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain>  <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain>  <20091008210737.GD29181@mit.edu>
  <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain>  <20091009091538.GA4154@elte.hu>  <1255097287.2934.21.camel@localhost.localdomain>  <20091012130652.GB25464@elte.hu>  <1255357148.2850.91.camel@localhost.localdomain>  <20091012145453.GD4565@elte.hu>
 <1255361148.2850.298.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756034AbZJLRZq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2009 13:25:46 -0400
In-Reply-To: <1255361148.2850.298.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>, Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jing Huang <huangj@brocade.com>



On Mon, 12 Oct 2009, James Bottomley wrote:
> > 
> > I think you are interpreting what should go into drivers/staging/ _very_ 
> > narrowly.
> 
> As it is my right to do.

Umm, James, it cuts both ways.

Others can assert their interpretation, and quite frankly, yours is the 
odd one out. Everybody else agrees oevrwhelmingly that "staging" is about 
ugly and not-up-to-snuff drivers.

So you can talk about your 'right' to interpret things all you want, but 
what's the point? If others haev the same right (which presumably even you 
agree they do), then if people think a driver is ugly and needs to be in 
staging, what makes _your_ right so special?

As mentioned earlier, I don't personally care about this driver, but I do 
care about your behavior. You can't just ignore other people if they say 
that a driver is too damn ugly.

			Linus
