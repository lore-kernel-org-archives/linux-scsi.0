Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C241EC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 13:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242946AbiAXNJV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 08:09:21 -0500
Received: from verein.lst.de ([213.95.11.211]:55704 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242940AbiAXNJU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jan 2022 08:09:20 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2C14568BEB; Mon, 24 Jan 2022 14:09:17 +0100 (CET)
Date:   Mon, 24 Jan 2022 14:09:17 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 07/13] block: move q_usage_counter release into
 blk_queue_release
Message-ID: <20220124130917.GF27269@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-8-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122111054.1126146-8-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jan 22, 2022 at 07:10:48PM +0800, Ming Lei wrote:
> After blk_cleanup_queue() returns, disk may not be released yet, so
> probably bio may still be submitted and ->q_usage_counter may be
> touched, so far this way seems safe, but not good from API's viewpoint.
> 
> Move the release ofq_usage_counter into blk_queue_release().

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
