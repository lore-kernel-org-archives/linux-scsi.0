Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FBDEB64D9
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 12:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjGFMkU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jul 2023 08:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjGFMkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2023 08:40:19 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89931BD6;
        Thu,  6 Jul 2023 05:40:16 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2A47467373; Thu,  6 Jul 2023 14:40:14 +0200 (CEST)
Date:   Thu, 6 Jul 2023 14:40:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/5] nvme: zns: Set zone limits before revalidating
 zones
Message-ID: <20230706124013.GB12545@lst.de>
References: <20230630083935.433334-1-dlemoal@kernel.org> <20230630083935.433334-3-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630083935.433334-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 30, 2023 at 05:39:32PM +0900, Damien Le Moal wrote:
> In nvme_revalidate_zones(), execute blk_queue_chunk_sectors() and
> blk_queue_max_zone_append_sectors() to respectively set a ZNS namespace
> zone size and maximum zone append sector limit before executing
> blk_revalidate_disk_zones(). This is to allow the block layer zone
> reavlidation to check these device characteristics prior to checking all
> zones of the device.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

