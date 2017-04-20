From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 22/23] blktrace: remove the unused block_rq_abort
 tracepoint
Date: Thu, 20 Apr 2017 17:38:56 +0200
Message-ID: <20170420153856.GR13676@linux-x5ow.site>
References: <20170420140316.6546-1-hch@lst.de>
 <20170420140316.6546-23-hch@lst.de>
 <20170420152056.GP13676@linux-x5ow.site>
 <20170420152558.GA23516@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170420152558.GA23516@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 20, 2017 at 05:25:58PM +0200, Christoph Hellwig wrote:
> On Thu, Apr 20, 2017 at 05:20:56PM +0200, Johannes Thumshirn wrote:
> > On Thu, Apr 20, 2017 at 04:03:15PM +0200, Christoph Hellwig wrote:
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > 
> > Just to be sure nothings forgotten, does this change need an update for
> > blktrace as well?
> 
> I don't think so.  It will just never get this event before or after
> this patch.

Ok then,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
