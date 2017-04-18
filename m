From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 16/25] xen-blkfront: don't use req->errors
Date: Tue, 18 Apr 2017 11:05:33 -0400
Message-ID: <20170418150533.GA12001@char.us.oracle.com>
References: <20170406153944.10058-1-hch@lst.de>
 <20170406153944.10058-17-hch@lst.de>
 <20170418150051.muglaxwfydaxypd6@dhcp-3-128.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19973 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752813AbdDRPGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 11:06:17 -0400
Content-Disposition: inline
In-Reply-To: <20170418150051.muglaxwfydaxypd6@dhcp-3-128.uk.xensource.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

On Tue, Apr 18, 2017 at 04:00:51PM +0100, Roger Pau Monné wrote:
> On Thu, Apr 06, 2017 at 05:39:35PM +0200, Christoph Hellwig wrote:
> > xen-blkfron is the last users using rq->errros for passing back error to
> > blk-mq, and I'd like to get rid of that.  In the longer run the driver
> > should be moving more of the completion processing into .complete, but
> > this is the minimal change to move forward for now.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: Roger Pau Monné <roger.pau@citrix.com>
> 

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thanks!
