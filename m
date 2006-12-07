From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Thu, 07 Dec 2006 17:02:08 +0900
Message-ID: <20061207170208R.fujita.tomonori@lab.ntt.co.jp>
References: <454FAD72.6040103@torque.net>
	<45503A3B.5050107@garzik.org>
	<20061107153147.GV19471@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44250 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031821AbWLGICf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2006 03:02:35 -0500
In-Reply-To: <20061107153147.GV19471@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: jeff@garzik.org, dougg@torque.net, linux-scsi@vger.kernel.org, axboe@suse.de

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Tue, 7 Nov 2006 16:31:48 +0100

> On Tue, Nov 07 2006, Jeff Garzik wrote:
> > Douglas Gilbert wrote:
> > >I was asked to put together a proposal in May this
> > >year for a new SCSI Generic interface structure. This
> > >is the same structure that is used by the block layer
> > >SG_IO ioctl. A few people have asked whether I had forgotten
> > >that I agreed to write the proposal. So here it is. Those
> > >who have seen it have made comments, some of which have
> > >been incorporated.
> > >
> > >Some shortcomings of the sg version 3 interface are:
> > >  - can't handle commands with bidirectional data (either
> > >    can the SCSI subsystem at the moment)
> > >  - if it was a bit more general it could carry other
> > >    request/response protocols (e.g. Task Management
> > >    Functions and SMP in Serial Attached SCSI)
> > >  - no way of associating a task attribute or task tag
> > >    with a SCSI command
> > 
> > Why avoid Jens Axboe's bsg?
> > 
> > It seems like that is already a good interface for carrying other 
> > req/resp protocols.
> 
> I don't think Doug is avoiding that (if you are Doug, please do explain
> :-), but rather outlining the next generation command format that bsg
> should support for future use.

sg4 can be implemented on bsg nicely, I think. But why does the
current bsg support sg3 partially? Do you plan to add the rest of sg3
(which doesn't work nicely) to bsg?
