From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.28-rc7
Date: Wed, 3 Dec 2008 14:10:52 +0100
Message-ID: <20081203131052.GS18255@kernel.dk>
References: <1228237136.3331.17.camel@localhost.localdomain> <20081202192834.GA26259@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:24878 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbYLCNK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2008 08:10:56 -0500
Content-Disposition: inline
In-Reply-To: <20081202192834.GA26259@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, Dec 02 2008, Bob Tracy wrote:
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

Please also try -git tomorrow, with this and the block pull hopefully
going in later today, I hope that's the end of it. If not, please do
write a proper report!

-- 
Jens Axboe

