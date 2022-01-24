Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134FCC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 13:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242937AbiAXNGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 08:06:23 -0500
Received: from verein.lst.de ([213.95.11.211]:55694 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242933AbiAXNGT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jan 2022 08:06:19 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B549B68BEB; Mon, 24 Jan 2022 14:06:16 +0100 (CET)
Date:   Mon, 24 Jan 2022 14:06:16 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 06/13] block: don't remove hctx debugfs dir from
 blk_mq_exit_queue
Message-ID: <20220124130616.GE27269@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-7-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122111054.1126146-7-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jan 22, 2022 at 07:10:47PM +0800, Ming Lei wrote:
> The queue's top debugfs dir is removed from blk_release_queue(), so all
> hctx's debugfs dirs are removed from there. Given blk_mq_exit_queue()
> is only called from blk_cleanup_queue(), it isn't necessary to remove
> hctx debugfs from blk_mq_exit_queue().
> 
> So remove it from blk_mq_exit_queue().

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
