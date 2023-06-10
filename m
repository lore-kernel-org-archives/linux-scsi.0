Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17170C7EE2E
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Jun 2023 06:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjFJGuj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Jun 2023 02:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjFJGuh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jun 2023 02:50:37 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103573A8D;
        Fri,  9 Jun 2023 23:50:37 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1131E68BEB; Sat, 10 Jun 2023 08:50:34 +0200 (CEST)
Date:   Sat, 10 Jun 2023 08:50:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     hch@lst.de, axboe@kernel.dk, dgilbert@interlog.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v5 1/3] blktrace: use inline function for
 blk_trace_remove() while blktrace is disabled
Message-ID: <20230610065033.GA2162@lst.de>
References: <20230610022003.2557284-1-yukuai1@huaweicloud.com> <20230610022003.2557284-2-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230610022003.2557284-2-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
