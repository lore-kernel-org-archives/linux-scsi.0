From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Thu, 8 Oct 2009 17:07:37 -0400
Message-ID: <20091008210737.GD29181@mit.edu>
References: <1254844007.4383.85.camel@mulgrave.site> <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain> <1254862442.4383.183.camel@mulgrave.site> <1255012399.4187.24.camel@mulgrave.site> <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain> <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain> <1255031298.4187.260.camel@mulgrave.site> <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain> <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43265 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253AbZJHVIW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Oct 2009 17:08:22 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, Oct 08, 2009 at 01:00:58PM -0700, Linus Torvalds wrote:
> 
> It really boils down to the fact that I'm perfectly happy to let new 
> drivers slip in after the merge window in order to help end users. But 
> really - there has to be a limit to it. Not just anything.
> 
> It has to help end users, and dammit, you have to admit that 50 kloc is 
> damn well not just "another random driver".

So would it be acceptable to merge the 50 kloc of crap _during_ the
merge window?  Crap is crap, no matter when it is merged.  In this
particular case, the crap is its own subsystem, and wouldn't interfere
with the rest of the kernel tree.  So it's no more risky to merge it
outside of merge window; so the decision about whether merge 50 kloc
of crap shouldn't be impacted about whether we are in our out of the
merge window.

Arguably, the question is whether it's better for the end users to
merge this at _any_ time, or whether we force the manufacturer to drop
it into the staging tree provisionally until it can be cleaned up.

   	    	    	 	       	     	- Ted
