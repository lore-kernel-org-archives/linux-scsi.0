From: Jens Axboe <axboe@suse.de>
Subject: Re: CDC_RAM for lk 2.4, PATCH proposed
Date: Fri, 4 Jun 2004 17:24:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040604152422.GE1946@suse.de>
References: <20040604145346.GA18777@logos.cnet> <1086362327.16498.21.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:18315 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265810AbUFDPZ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2004 11:25:26 -0400
Content-Disposition: inline
In-Reply-To: <1086362327.16498.21.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-scsi@vger.kernel.org, John McKell <McKellj@iomega.com>

On Fri, Jun 04 2004, Pat LaVarre wrote:
> Marcelo T:
> 
> > > > > > http://marc.theaimsgroup.com/?l=linux-scsi&m=108509426227562
> > > > > > > diff -Nurp linux-2.4.27-pre3/... linux-2.4.27-pre3-pel/...
> > > > > > 
> > > > > > [snip]
> > > > > > 
> > > > > > Patch looks fine to me,
> > > > > > I'll send it to Marcelo for inclusion. Thanks!
> > ...
> > Please resend me.
> 
> Thank you for helping.
> 
> Inline below is a copy of the Axboe-approved version, taken from:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=108509426227562&q=raw
> 
> Be aware, meanwhile, offline an issue has arisen in 2.6 whose fix is
> also now being backported to 2.4.  I don't myself yet fully understand
> that discussion, but I will try to post a 2.4 fix today here (UTC-7+1).
> 
> Please tell me if you want one combined substitute patch, or an
> incremental like 2.6 gets.

I already sent an updated to Marcelo 5 minutes ago which has that fixed
incorporated. JFYI Marcelo, apply that version and the above is void.

-- 
Jens Axboe

