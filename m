Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 517B5EB64D9
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 12:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjGFMlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jul 2023 08:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjGFMlt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2023 08:41:49 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6D61AD;
        Thu,  6 Jul 2023 05:41:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9159667373; Thu,  6 Jul 2023 14:41:45 +0200 (CEST)
Date:   Thu, 6 Jul 2023 14:41:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 4/5] block: virtio_blk: Set zone limits before
 revalidating zones
Message-ID: <20230706124145.GD12545@lst.de>
References: <20230630083935.433334-1-dlemoal@kernel.org> <20230630083935.433334-5-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630083935.433334-5-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
