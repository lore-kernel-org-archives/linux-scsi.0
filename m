From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 22/23] blktrace: remove the unused block_rq_abort
        tracepoint
Date: Thu, 20 Apr 2017 17:25:58 +0200
Message-ID: <20170420152558.GA23516@lst.de>
References: <20170420140316.6546-1-hch@lst.de> <20170420140316.6546-23-hch@lst.de> <20170420152056.GP13676@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41238 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967294AbdDTP0A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 11:26:00 -0400
Content-Disposition: inline
In-Reply-To: <20170420152056.GP13676@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

On Thu, Apr 20, 2017 at 05:20:56PM +0200, Johannes Thumshirn wrote:
> On Thu, Apr 20, 2017 at 04:03:15PM +0200, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Just to be sure nothings forgotten, does this change need an update for
> blktrace as well?

I don't think so.  It will just never get this event before or after
this patch.
