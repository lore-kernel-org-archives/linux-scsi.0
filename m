From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/8] blk-mq: bidi support
Date: Wed, 16 Apr 2014 18:44:06 +0200
Message-ID: <20140416164406.GA19850@lst.de>
References: <1397634299-7466-1-git-send-email-hch@lst.de> <1397634299-7466-3-git-send-email-hch@lst.de> <534EB2BA.7020705@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58528 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaDPQoJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Apr 2014 12:44:09 -0400
Content-Disposition: inline
In-Reply-To: <534EB2BA.7020705@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Apr 16, 2014 at 10:41:30AM -0600, Jens Axboe wrote:
> > -	if (!q->request_fn)
> > +	if (!q->request_fn && !q->mq_ops)
> >  		return 0;
> >  
> >  	bcd = &q->bsg_dev;
> 
> This looks misplaced. But I dropped the one I generated last week, I'll
> queue it up separately in the drivers branch.

Could be argued that it should be a separate patch, but the check should
work fine.
