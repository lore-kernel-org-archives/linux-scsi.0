From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.39-rc3-git3 crashs after booting
Date: Thu, 14 Apr 2011 20:43:16 +0200
Message-ID: <20110414184316.GA16064@elte.hu>
References: <web-504663160@zbackend1.aha.ru>
 <20110414104039.c0e655bd.akpm@linux-foundation.org>
 <1302803619.9800.4.camel@mulgrave.site>
 <20110414181514.GA13977@elte.hu>
 <1302805952.9800.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:56228 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab1DNSni (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2011 14:43:38 -0400
Content-Disposition: inline
In-Reply-To: <1302805952.9800.7.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>, gregkh@suse.de, tj@kernel.org, randy.dunlap@oracle.com, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2011-04-14 at 20:15 +0200, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > +	/* temporary expedient, try to catch use of queue lock after
> > > +	 * free of sdev */
> > > +	sdev->request_queue = NULL;
> > 
> > Couldnt help to notice this small ugliness while skimming the patch - please 
> > use the customary (multi-line) comment style:
> > 
> >   /*
> >    * Comment .....
> >    * ...... goes here.
> >    */
> 
> It's just code motion, so it was cut and paste. The actual file is a nasty 
> mix of comment styles, so it doesn't really matter one way or the other.

That's not really true - most other multi-line comments are fine in that file - 
i checked that before sending my feedback.

Really, why are you even arguing about it? You have not noticed it during 
review - that can happen - but you should really fix small details if someone 
points them out during review. Instead you are forcing reviewers though an 
unnecessary and time-wasting email exchange.

Thanks,

	Ingo
