From: Christoph Hellwig <hch@lst.de>
Subject: Re: sense handling improvements
Date: Wed, 15 Feb 2017 16:04:06 +0100
Message-ID: <20170215150406.GA26549@lst.de>
References: <20170214191600.17480-1-hch@lst.de> <cfc712df-f0e6-59c0-46d8-6af02542f14b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cfc712df-f0e6-59c0-46d8-6af02542f14b@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernek.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 15, 2017 at 09:19:18AM +0100, Hannes Reinecke wrote:
> On 02/14/2017 08:15 PM, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series is on top of the scsi_request changes in Jens' tree and
> > further improves the handling of the sense buffer.
> > 
> Sorry, but I'm feeling really daft: which scsi_request changes?

That is the "split scsi passthrough fields out of struct request"
series.

> To be found in which tree?

Jens' for-next tree, as mentioned above.

> Have we audited all drivers to _not_ do DMA into the sense buffer?
> By first glance some still do, so they'll break horribly when moving the
> sense buffer onto the stack ...

With the above series the sense buffer is allocate by the driver,
and they will always DMA into that.
