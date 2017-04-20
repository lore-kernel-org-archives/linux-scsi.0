From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 22/23] blktrace: remove the unused block_rq_abort
 tracepoint
Date: Thu, 20 Apr 2017 12:13:14 -0600
Message-ID: <20170420181313.GB22378@kernel.dk>
References: <20170420140316.6546-1-hch@lst.de>
 <20170420140316.6546-23-hch@lst.de>
 <20170420152056.GP13676@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36519 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971233AbdDTSNQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 14:13:16 -0400
Received: by mail-io0-f181.google.com with SMTP id o22so88431343iod.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2017 11:13:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170420152056.GP13676@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

On Thu, Apr 20 2017, Johannes Thumshirn wrote:
> On Thu, Apr 20, 2017 at 04:03:15PM +0200, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Just to be sure nothings forgotten, does this change need an update for
> blktrace as well?

blktrace doesn't use this event for anything internally, so the change is
fine.

-- 
Jens Axboe
