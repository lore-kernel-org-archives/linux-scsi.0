From: Jeff Garzik <jeff@garzik.org>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Tue, 07 Nov 2006 02:48:11 -0500
Message-ID: <45503A3B.5050107@garzik.org>
References: <454FAD72.6040103@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:29360 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1752387AbWKGHsO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2006 02:48:14 -0500
In-Reply-To: <454FAD72.6040103@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

Douglas Gilbert wrote:
> I was asked to put together a proposal in May this
> year for a new SCSI Generic interface structure. This
> is the same structure that is used by the block layer
> SG_IO ioctl. A few people have asked whether I had forgotten
> that I agreed to write the proposal. So here it is. Those
> who have seen it have made comments, some of which have
> been incorporated.
> 
> Some shortcomings of the sg version 3 interface are:
>   - can't handle commands with bidirectional data (either
>     can the SCSI subsystem at the moment)
>   - if it was a bit more general it could carry other
>     request/response protocols (e.g. Task Management
>     Functions and SMP in Serial Attached SCSI)
>   - no way of associating a task attribute or task tag
>     with a SCSI command

Why avoid Jens Axboe's bsg?

It seems like that is already a good interface for carrying other 
req/resp protocols.

	Jeff


