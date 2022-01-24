Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A8EC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 12:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242865AbiAXM7o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 07:59:44 -0500
Received: from verein.lst.de ([213.95.11.211]:55634 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242968AbiAXM7d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jan 2022 07:59:33 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0236968C4E; Mon, 24 Jan 2022 13:59:27 +0100 (CET)
Date:   Mon, 24 Jan 2022 13:59:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 01/13] block: declare blkcg_[init|exit]_queue in
 private header
Message-ID: <20220124125927.GA27269@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122111054.1126146-2-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jan 22, 2022 at 07:10:42PM +0800, Ming Lei wrote:
> Both two functions are used by block core code only, so move the
> declaration into private header of block layer.

Hmm.  Given how much of blk-cgroup.h is private I wonder if moving most
of it to block/blk-cgroup.h and just keeping a small public header might
be a better idea.
