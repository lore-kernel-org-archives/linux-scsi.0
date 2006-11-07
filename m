From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Tue, 7 Nov 2006 16:31:48 +0100
Message-ID: <20061107153147.GV19471@kernel.dk>
References: <454FAD72.6040103@torque.net> <45503A3B.5050107@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:40812 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1754050AbWKGP3h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2006 10:29:37 -0500
Content-Disposition: inline
In-Reply-To: <45503A3B.5050107@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

On Tue, Nov 07 2006, Jeff Garzik wrote:
> Douglas Gilbert wrote:
> >I was asked to put together a proposal in May this
> >year for a new SCSI Generic interface structure. This
> >is the same structure that is used by the block layer
> >SG_IO ioctl. A few people have asked whether I had forgotten
> >that I agreed to write the proposal. So here it is. Those
> >who have seen it have made comments, some of which have
> >been incorporated.
> >
> >Some shortcomings of the sg version 3 interface are:
> >  - can't handle commands with bidirectional data (either
> >    can the SCSI subsystem at the moment)
> >  - if it was a bit more general it could carry other
> >    request/response protocols (e.g. Task Management
> >    Functions and SMP in Serial Attached SCSI)
> >  - no way of associating a task attribute or task tag
> >    with a SCSI command
> 
> Why avoid Jens Axboe's bsg?
> 
> It seems like that is already a good interface for carrying other 
> req/resp protocols.

I don't think Doug is avoiding that (if you are Doug, please do explain
:-), but rather outlining the next generation command format that bsg
should support for future use.

-- 
Jens Axboe

