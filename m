Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42E1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 12:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbiCAM5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 07:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiCAM5Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 07:57:16 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A755996B9;
        Tue,  1 Mar 2022 04:56:36 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BB10268AFE; Tue,  1 Mar 2022 13:56:32 +0100 (CET)
Date:   Tue, 1 Mar 2022 13:56:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: move more work to disk_release v2
Message-ID: <20220301125632.GA3911@lst.de>
References: <20220227172144.508118-1-hch@lst.de> <741e087a-43f8-dc90-b679-7865cf503ac3@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <741e087a-43f8-dc90-b679-7865cf503ac3@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Feb 27, 2022 at 03:18:24PM -0800, Bart Van Assche wrote:
> The second issue I run into with this branch is as follows
> (also for nvmeof-mp/002):

You'll need this patch, which is only in mainline but not the
for-5.18/block branch:

fd9f4e62a39f09a7c014d7415c2b9d1390aa0504
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Jan 18 08:04:44 2022 +0100

    block: assign bi_bdev for cloned bios in blk_rq_prep_clone

