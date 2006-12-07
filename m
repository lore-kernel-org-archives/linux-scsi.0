From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Thu, 07 Dec 2006 17:21:33 +0900
Message-ID: <20061207172133L.fujita.tomonori@lab.ntt.co.jp>
References: <20061107153147.GV19471@kernel.dk>
	<20061207170208R.fujita.tomonori@lab.ntt.co.jp>
	<20061207080657.GX4392@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:39749 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031842AbWLGIVk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2006 03:21:40 -0500
In-Reply-To: <20061207080657.GX4392@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, dougg@torque.net, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Thu, 7 Dec 2006 09:06:59 +0100

> On Thu, Dec 07 2006, FUJITA Tomonori wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: RFC: SCSI Generic version 4 interface
> > Date: Tue, 7 Nov 2006 16:31:48 +0100
> > 
> > > On Tue, Nov 07 2006, Jeff Garzik wrote:
> > > > Douglas Gilbert wrote:
> > > > >I was asked to put together a proposal in May this
> > > > >year for a new SCSI Generic interface structure. This
> > > > >is the same structure that is used by the block layer
> > > > >SG_IO ioctl. A few people have asked whether I had forgotten
> > > > >that I agreed to write the proposal. So here it is. Those
> > > > >who have seen it have made comments, some of which have
> > > > >been incorporated.
> > > > >
> > > > >Some shortcomings of the sg version 3 interface are:
> > > > >  - can't handle commands with bidirectional data (either
> > > > >    can the SCSI subsystem at the moment)
> > > > >  - if it was a bit more general it could carry other
> > > > >    request/response protocols (e.g. Task Management
> > > > >    Functions and SMP in Serial Attached SCSI)
> > > > >  - no way of associating a task attribute or task tag
> > > > >    with a SCSI command
> > > > 
> > > > Why avoid Jens Axboe's bsg?
> > > > 
> > > > It seems like that is already a good interface for carrying other 
> > > > req/resp protocols.
> > > 
> > > I don't think Doug is avoiding that (if you are Doug, please do explain
> > > :-), but rather outlining the next generation command format that bsg
> > > should support for future use.
> > 
> > sg4 can be implemented on bsg nicely, I think. But why does the
> > current bsg support sg3 partially? Do you plan to add the rest of sg3
> > (which doesn't work nicely) to bsg?
> 
> What parts of sg v3 are missing? It's been a while since I implemented
> that stuff, so I forget if I knowingly left out some features.

SG_FLAG_MMAP_IO, indirect IO, probably I miss something more.

