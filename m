From: Jens Axboe <axboe@kernel.dk>
Subject: Re: kill req->errors V4
Date: Thu, 20 Apr 2017 12:16:55 -0600
Message-ID: <20170420181654.GC22378@kernel.dk>
References: <20170420140316.6546-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170420140316.6546-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 20 2017, Christoph Hellwig wrote:
> Currently the request structure has an errors field that is used in
> various different ways.  The oldest drivers use it as an error count,
> blk-mq and the generic timeout code assume that it holds a Linux
> errno for block completions, and various drivers use it for internal
> status values, often overwriting them with Linux errnos later,
> that is unless they are processing passthrough requests in which
> case they'll leave their errors in it.
> 
> This series kills the ->errors field and replaced it with new fields
> in the drivers (or an odd hack in a union in struct request for
> two bitrotting old drivers).

Applied for 4.12, thanks.

-- 
Jens Axboe
