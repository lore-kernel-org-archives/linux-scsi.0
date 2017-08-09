From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] scsi: add Mylex RAID controller
Date: Wed, 9 Aug 2017 16:10:49 +0200
Message-ID: <20170809141049.GB26843@lst.de>
References: <1501683208-5240-1-git-send-email-hare@suse.de> <1501683208-5240-4-git-send-email-hare@suse.de> <20170805113932.GF16313@lst.de> <17589cb4-9f0c-7d15-8c3a-79bd9b14fdef@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17589cb4-9f0c-7d15-8c3a-79bd9b14fdef@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 07, 2017 at 08:09:11AM +0200, Hannes Reinecke wrote:
> On 08/05/2017 01:39 PM, Christoph Hellwig wrote:
> > Can you use normal linux style for the code instead of copy and
> > pasting the weird naming and capitalization from the DAC960 driver?
> > 
> Yes; already planned for v2. But first wanted to get some general
> feedback (like: is anyone interested in that at all?)

Yes, please go ahead and kill off the DAC960 driver.

> 
> > Also please use the driver name as prefix for the functions.
> > 
> Ok.
> 
> > Maybe myraid instead of mylex?
> > 
> Nah; I'd rather stick with mylex.
> (Especially as it says 'Mylex' in big fat letters on the board :-)

Naming drivers after the vendor only is usually a bad idea as vendors
have/had multiple products.  In this case we have plenty other drivers
that support Mylex products.
