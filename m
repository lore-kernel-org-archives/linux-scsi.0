From: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [PATCH 16/25] xen-blkfront: don't use req->errors
Date: Tue, 18 Apr 2017 16:00:51 +0100
Message-ID: <20170418150051.muglaxwfydaxypd6@dhcp-3-128.uk.xensource.com>
References: <20170406153944.10058-1-hch@lst.de>
 <20170406153944.10058-17-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.ctxuk.citrix.com ([185.25.65.24]:58601 "EHLO
        SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752531AbdDRPBU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 11:01:20 -0400
Content-Disposition: inline
In-Reply-To: <20170406153944.10058-17-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

On Thu, Apr 06, 2017 at 05:39:35PM +0200, Christoph Hellwig wrote:
> xen-blkfron is the last users using rq->errros for passing back error to
> blk-mq, and I'd like to get rid of that.  In the longer run the driver
> should be moving more of the completion processing into .complete, but
> this is the minimal change to move forward for now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Roger Pau Monné <roger.pau@citrix.com>
