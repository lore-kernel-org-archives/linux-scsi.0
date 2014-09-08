From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 0/6] blk-mq: initialize pdu of flush req explicitly
Date: Tue, 9 Sep 2014 00:55:03 +0800
Message-ID: <CACVXFVP-kUkCoW_pPrxqKWeoSKkxCACLLth2ycv87EVzfr2mUA@mail.gmail.com>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
	<20140907184956.GB23026@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33293 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbaIHQzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2014 12:55:07 -0400
In-Reply-To: <20140907184956.GB23026@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Mon, Sep 8, 2014 at 2:49 AM, Christoph Hellwig <hch@lst.de> wrote:
> This works fine for me, although I still don't really like it very much.
>
> If you really want to go down the path of major surgery in this area we
> should probably allocate a flush request per hw_ctx, and initialize it
> using the normal init/exit functions.  If we want to have proper multiqueue
> performance on devices needing flushes we'll need something like that anyway.

Yes, that should be the final solution for the problem, and looks the whole
flush machinery need to move into hctx, I will try to figure out one patch to
do that.

Thanks,
