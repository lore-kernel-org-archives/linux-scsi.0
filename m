Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA97FC04FEE
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 19:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjITT2R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 15:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjITT2Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 15:28:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF88C9;
        Wed, 20 Sep 2023 12:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gxDoj7maXxtauBpJJeW7FYZYQgCXS1jm/87Hs+hpRMI=; b=DA9QOM8R+gXea4XMiFxu8mAUbG
        OOBhNcUthiOYgYf7Rd0/qkjLGUkjpoBnQHl7oYE+dLTf1H1FXHKem3MVj7q0+cHupoAAb8IrCPW5N
        zoJs6CP3eer04wG6jXmWxUpQnreajQvIjpOr+8pUu5RBBSrqI2exvkRUc5FwW3RHKAAh5u3HxrKzZ
        dIVrVOwFyWH4TlJQZYnIxKnmqdLSZSwkeMss8O4n2Z3sTXyrIJxQpeZr+8J4MTK1bZL3pvlH9+XfR
        zJXR64rQxQ2BG+EHxuWa842SQJxCIK+ji889dp9pQ8870iFIdcfRjWh7FBhXny29lXNmSJrKTs5iw
        +ZjXyfGg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qj2ri-007ZI4-PB; Wed, 20 Sep 2023 19:28:02 +0000
Date:   Wed, 20 Sep 2023 20:28:02 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/13] Pass data temperature information to zoned UFS
 devices
Message-ID: <ZQtHwsNvS1wYDKfG@casper.infradead.org>
References: <20230920191442.3701673-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920191442.3701673-1-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 20, 2023 at 12:14:25PM -0700, Bart Van Assche wrote:
> Hi Jens,
> 
> Zoned UFS vendors need the data temperature information. Hence this patch
> series that restores write hint information in F2FS and in the block layer.
> The SCSI disk (sd) driver is modified such that it passes write hint
> information to SCSI devices via the GROUP NUMBER field.

"Need" in what sense?  Can you quantify what improvements we might
see from this patchset?
