From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Is there a grand plan for FC failover?
Date: 29 Jan 2004 11:00:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075392058.2381.44.camel@mulgrave>
References: <401521A7.5030808@thekelleys.org.uk>
	<1075131446.2290.29.camel@mulgrave>
	<20040128100236.D11527@vienna.EGENERA.COM>
	<1075309052.2254.6.camel@mulgrave>
	<20040128130040.E11527@vienna.EGENERA.COM> <401839A8.307@us.ibm.com>
	<20040129102430.G11527@vienna.EGENERA.COM>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:44230 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266021AbUA2QBu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 11:01:50 -0500
In-Reply-To: <20040129102430.G11527@vienna.EGENERA.COM>
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: Mike Christie <mikenc@us.ibm.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-01-29 at 10:24, Philip R. Auld wrote:
> I think the place to do load balancing would be below the block queue so that
> the IOs are coalesced. IMO, until you've merged the individual block requests 
> you can't make a good decision about how to balance the load. 

Yes, that's what I think too, so the elevator should go above dm, with a
vestigial elevator between dm and sd simply for SCSI to use in queuing.

Unfortunately, the way it works today is that the elevator is between dm
and sd.  I know people are thinking about how to change this, but I'm
not sure how far anyone's got.

James


