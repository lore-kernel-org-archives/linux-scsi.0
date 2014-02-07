From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/4] minor blk-mq updates
Date: Fri, 7 Feb 2014 13:45:55 -0700
Message-ID: <20140207204555.GB23865@kernel.dk>
References: <20140207182235.659185141@bombadil.infradead.org>
 <1391801805.1155.30.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1391801805.1155.30.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 07 2014, Nicholas A. Bellinger wrote:
> On Fri, 2014-02-07 at 10:22 -0800, Christoph Hellwig wrote:
> > Hi Jens,
> > 
> > these small blk-mq core updates fell out of the scsi multiqueue work.
> 
> That reminds me, the following blk-mq patch was required to get DIF
> working with scsi-mq.
> 
> Jens, care to pick this up as well..?

Yep, added, thanks!

-- 
Jens Axboe
