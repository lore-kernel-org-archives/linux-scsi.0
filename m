From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH resend] bsg: Add support for submitting requests at
	tail of queue
Date: Tue, 24 Mar 2009 13:14:38 +0100
Message-ID: <20090324121438.GQ27476@kernel.dk>
References: <49C20CCD.5070607@panasas.com> <49C89CBC.7050306@panasas.com> <20090324210440Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:42946 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbZCXMOk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 08:14:40 -0400
Content-Disposition: inline
In-Reply-To: <20090324210440Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, linux-scsi@vger.kernel.org, osd-dev@open-osd.org, dgilbert@interlog.com

On Tue, Mar 24 2009, FUJITA Tomonori wrote:
> On Tue, 24 Mar 2009 10:41:32 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > Boaz Harrosh wrote:
> > > Hi Tomo Jens
> > > 
> > > Tomo you never ack-by on this patch. I absolutely needs this for the
> > > user-mode API of osd-initiator. Which is needed with up-coming exofs
> > > utilities.
> > > 
> > > What do you want to do?
> > > 
> > > Thanks 
> > > 
> > 
> > Hi Jens.
> > 
> > I absolutely need this patch for 2.6.30 merge window. It is totally
> > un-dangerous since defaults are left unchanged.
> 
> The question is we really need this feature or not. Though I guess
> that we need to address this starvation issue.

I'd argue that tail insertion should be the most used way to queue
commands, head insertion should only be for the cases where you want
immediate access (like error handling).

-- 
Jens Axboe

