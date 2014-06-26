From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: scsi-mq V2
Date: Thu, 26 Jun 2014 22:07:29 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B4EFB4@G9W0745.americas.hpqcorp.net>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <53ABA6A4.8090400@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:58125 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFZWKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2014 18:10:11 -0400
In-Reply-To: <53ABA6A4.8090400@kernel.dk>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Wednesday, 25 June, 2014 11:51 PM
> To: Christoph Hellwig; James Bottomley
> Cc: Bart Van Assche; Elliott, Robert (Server Storage); linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: scsi-mq V2
> 
> On 2014-06-25 10:51, Christoph Hellwig wrote:
> > This is the second post of the scsi-mq series.
> >
...
> >
> > Changes from V1:
> >   - rebased on top of the core-for-3.17 branch, most notable the
> >     scsi logging changes
> >   - fixed handling of cmd_list to prevent crashes for some heavy
> >     workloads
> >   - fixed incorrect handling of !target->can_queue
> >   - avoid scheduling a workqueue on I/O completions when no queues
> >     are congested
> >
> > In addition to the patches in this thread there also is a git available at:
> >
> > 	git://git.infradead.org/users/hch/scsi.git scsi-mq.2
> 
> You can add my acked/reviewed-by to the series.
> 
> --
> Jens Axboe

Since March 20th (circa LSF-MM 2014) we've run many hours of tests
with hpsa and the scsi-mq tree.  We've also done a little bit of 
testing with mpt3sas and, in the last few days, scsi_debug.

Although there are certainly more problems to find and improvements
to be made, it's become quite stable.  It's even been used on the
boot drives of our test servers.

For the patches in scsi-mq.2 you may add:
Tested-by: Robert Elliott <elliott@hp.com>


---
Rob Elliott    HP Server Storage



