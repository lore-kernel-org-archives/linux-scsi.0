From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: remove REQ_HARDBARRIER
Date: Mon, 25 Oct 2010 10:54:42 +0200
Message-ID: <4CC545D2.9020303@kernel.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com> <4CC311D5.9040904@fusionio.com> <20101023165924.GA1395@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:38648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0JYIyt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 04:54:49 -0400
In-Reply-To: <20101023165924.GA1395@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 10/23/2010 06:59 PM, Christoph Hellwig wrote:
> REQ_HARDBARRIER is dead now, so remove the leftovers.  What's left
> at this point is:
> 
>  - various checks inside the block layer.
>  - sanity checks in bio based drivers.
>  - now unused bio_empty_barrier helper.
>  - Xen blockfront use of BLKIF_OP_WRITE_BARRIER - it's dead for a while,
>    but Xen really needs to sort out it's barrier situaton.
>  - setting of ordered tags in uas - dead code copied from old scsi
>    drivers.
>  - scsi different retry for barriers - it's dead and should have been
>    removed when flushes were converted to FS requests.
>  - blktrace handling of barriers - removed.  Someone who knows blktrace
>    better should add support for REQ_FLUSH and REQ_FUA, though.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
