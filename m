From: Bob Tracy <rct@gherkin.frus.com>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.28-rc7
Date: Thu, 4 Dec 2008 08:30:23 -0600
Message-ID: <20081204143023.GA2240@gherkin.frus.com>
References: <1228237136.3331.17.camel@localhost.localdomain> <20081202192834.GA26259@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:58848 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbYLDOa0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2008 09:30:26 -0500
Content-Disposition: inline
In-Reply-To: <20081202192834.GA26259@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, Dec 02, 2008 at 01:28:34PM -0600, Bob Tracy wrote:
> On Tue, Dec 02, 2008 at 10:58:56AM -0600, James Bottomley wrote:
> > This is quite a hefty update for so late. It includes a slew of block
> > timer related fixes (we moved to using block timers when the 2.6.28
> > merge window opened).  The bad news is that I still don't think we have
> > all the block timer related bugs caught and fixed.  There's also a slew
> > of zfcp (s390 driver) fixes and a few miscellaneous others (including
> > another regression bugzilla fix, the hang in starved list processing).
> 
> I'll give this a try.  None of the 2.6.28-rcX versions I've tried have
> lasted more than a few hours at best before panicing with a block layer
> timeout.  My test system uses the aic7xxx driver with a 2930U2 adapter.
> I didn't report the regression relative to 2.6.27 because I figured
> something this major was going to get caught without another "me too"
> report that I was too busy to generate and provide the necessary
> diagnostic and followup on anyway :-).

2.6.28-rc7 without the SCSI update panics as the prior -rcX kernels did.
With the update applied, life is good (so far).  I can at least type
"sync" at the command prompt and get away with it :-).  With a current
uptime of less than 5 minutes, I need to let the patched -rc7 soak a
bit.  Otherwise, I'm willing to call it "good."

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
