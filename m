From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Thu, 8 Oct 2009 13:00:58 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain>
References: <1254844007.4383.85.camel@mulgrave.site>  <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>  <1254862442.4383.183.camel@mulgrave.site>  <1255012399.4187.24.camel@mulgrave.site>  <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
  <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain> <1255031298.4187.260.camel@mulgrave.site> <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933069AbZJHUBj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2009 16:01:39 -0400
In-Reply-To: <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>



On Thu, 8 Oct 2009, Linus Torvalds wrote:
> 
> What part of "sure, I'll take new drivers after the merge window, but COME 
> &*^@ ON!" do you have trouble understanding?

Put another way: look at the drivers/staging tree. Look at when it gets 
merged. Do this:

	git diff --stat v2.6.31-rc1..v2.6.31 drivers/staging/

and then do this:

	git diff --stat v2.6.30..v2.6.31-rc1 drivers/staging/

adn thing about the fact that they are _all_ "new drivers". Then consider 
the issue of "merge window" vs "not merge window".

It really boils down to the fact that I'm perfectly happy to let new 
drivers slip in after the merge window in order to help end users. But 
really - there has to be a limit to it. Not just anything.

It has to help end users, and dammit, you have to admit that 50 kloc is 
damn well not just "another random driver".

			Linus

