From: Jens Axboe <axboe@suse.de>
Subject: Re: CDC_RAM for lk 2.4, PATCH proposed
Date: Thu, 20 May 2004 10:06:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040520080622.GF1952@suse.de>
References: <20040519081534.GE30348@suse.de> <1084981551.3082.80.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:1926 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265036AbUETIGb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 04:06:31 -0400
Content-Disposition: inline
In-Reply-To: <1084981551.3082.80.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org, John McKell <McKellj@iomega.com>

On Wed, May 19 2004, Pat LaVarre wrote:
> Jens A:
> 
> > Please explain your reasoning for this patch.
> 
> I fear to answer fully, because I see I have a history of answering in
> ways that make you lose interest.

Sorry you feel that way. It's not loss of interesting, mainly juggling
other tasks.

> I see you have not yet volunteered to review the 2.4.26 patch proposed
> in this thread 2004-04-23 by John McKell, written to give us CDC_RAM
> alone without MRW in 2.4.
> 
> Can I help best by updating that patch to become a 2.4.27-pre3 patch?

2.4.26 patch should apply to 2.4.27-pre3 as well, I think. But it
doesn't hurt to check.

> ----- ----- -----
> 
> P.S. An alternative, less short reply that I also drafted was:
> 
> > > linux-2.4.18/drivers/ide/ide-cd.c
> > if we succeed in getting the mode sense capabilities page,
> > you force setting og dvd-rom/ram?!
> > ...
> > > linux-2.4.18/drivers/scsi/sr.c
> > Ditto here.
> 
> Yes.
> 
> I believe 2.4.18 patch actually makes `mount -w` work there by way of
> "see all DVD/CD drives as DVD-RAM/ DVD-ROM compatible".

But that's not what the patch does at all. The patch simply says "If we
succeeded in retriving the mode capability page, ignore what it says and
flag the drive as dvd-rom/ram capable" which is clearly bogus.

-- 
Jens Axboe

