From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH resend] bsg: Add support for submitting requests at
	tail of queue
Date: Tue, 24 Mar 2009 21:22:58 +0900
Message-ID: <20090324212248A.fujita.tomonori@lab.ntt.co.jp>
References: <49C89CBC.7050306@panasas.com>
	<20090324210440Z.fujita.tomonori@lab.ntt.co.jp>
	<20090324121438.GQ27476@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41478 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbZCXMXe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 08:23:34 -0400
In-Reply-To: <20090324121438.GQ27476@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, linux-scsi@vger.kernel.org, osd-dev@open-osd.org, dgilbert@interlog.com

On Tue, 24 Mar 2009 13:14:38 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Mar 24 2009, FUJITA Tomonori wrote:
> > On Tue, 24 Mar 2009 10:41:32 +0200
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> > > Boaz Harrosh wrote:
> > > > Hi Tomo Jens
> > > > 
> > > > Tomo you never ack-by on this patch. I absolutely needs this for the
> > > > user-mode API of osd-initiator. Which is needed with up-coming exofs
> > > > utilities.
> > > > 
> > > > What do you want to do?
> > > > 
> > > > Thanks 
> > > > 
> > > 
> > > Hi Jens.
> > > 
> > > I absolutely need this patch for 2.6.30 merge window. It is totally
> > > un-dangerous since defaults are left unchanged.
> > 
> > The question is we really need this feature or not. Though I guess
> > that we need to address this starvation issue.
> 
> I'd argue that tail insertion should be the most used way to queue
> commands, head insertion should only be for the cases where you want
> immediate access (like error handling).

As I wrote, I think that we need to address this starvation issue.

But nobody has complained about this (with sg and bsg) for years
because we have not seen applications sending scsi commands that are
many enough to make a queue full. So it's worth knowing what unknown
applications do for what, I think.
