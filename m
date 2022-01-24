Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99ABC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 13:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243147AbiAXNQh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 08:16:37 -0500
Received: from verein.lst.de ([213.95.11.211]:55762 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243145AbiAXNQ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jan 2022 08:16:27 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id DE3F268BEB; Mon, 24 Jan 2022 14:16:24 +0100 (CET)
Date:   Mon, 24 Jan 2022 14:16:24 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 10/13] block: add helper of disk_release_queue for
 release queue data for disk
Message-ID: <20220124131624.GI27269@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-11-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122111054.1126146-11-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jan 22, 2022 at 07:10:51PM +0800, Ming Lei wrote:
> Add one helper of disk_release_queue for releasing queue data for disk.

Please explain what "queue data for disk" is, and why this helper is
useful.  Right now it seems to just move a few things around without a
rationale or explanation of why it is safe.
