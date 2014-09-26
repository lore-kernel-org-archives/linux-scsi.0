From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: Question: request tag usage
Date: Fri, 26 Sep 2014 13:52:23 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C9FC0A@G9W0745.americas.hpqcorp.net>
References: <542507C9.2060901@suse.de>
 <20140926080308.GA21137@infradead.org> <542521DB.1020605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:55320 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaIZNxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2014 09:53:18 -0400
In-Reply-To: <542521DB.1020605@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, September 26, 2014 3:21 AM
> To: Christoph Hellwig
> Cc: Elliott, Robert (Server Storage); SCSI Mailing List; Jens Axboe
> Subject: Re: Question: request tag usage
> 
> On 09/26/2014 10:03 AM, Christoph Hellwig wrote:
...
> >
> > I guess for now we'll need to stay with the command pointer address.
> > We can revisit this once the old request layer is gone.
> >
> Too bad. The tags would have provided a really nice concise way
> of identifying the command...

I would still go ahead and print the tag; it's extremely useful for
blk-mq.

How about having scmd_printk do this?
* if tag is -1, print "scmd %p"
* else print "tag %d"

