From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH resend] bsg: Add support for submitting requests at
	tail  of queue
Date: Tue, 24 Mar 2009 12:23:11 +0100
Message-ID: <20090324112311.GH27476@kernel.dk>
References: <49C20CCD.5070607@panasas.com> <49C89CBC.7050306@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:52352 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbZCXLXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 07:23:13 -0400
Content-Disposition: inline
In-Reply-To: <49C89CBC.7050306@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, Douglas Gilbert <dgilbert@interlog.com>

On Tue, Mar 24 2009, Boaz Harrosh wrote:
> Boaz Harrosh wrote:
> > Hi Tomo Jens
> > 
> > Tomo you never ack-by on this patch. I absolutely needs this for the
> > user-mode API of osd-initiator. Which is needed with up-coming exofs
> > utilities.
> > 
> > What do you want to do?
> > 
> > Thanks 
> > 
> 
> Hi Jens.
> 
> I absolutely need this patch for 2.6.30 merge window. It is totally
> un-dangerous since defaults are left unchanged.
> 
> I need it because the user-mode utilities for osd and exofs that
> correspond to code in 2.6.30 will need this patch to compile,
> because they use a flag constant defined in this patch.
> 
> I'm not getting any response from Tomo, some of the emails I send bounce,
> do you know if he is on vacation or something?

I don't know if Tomo is away or not, but I've added your patch for
2.6.30 now at least.

-- 
Jens Axboe

