Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4E8C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 15:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243351AbiCBPEJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiCBPEH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 10:04:07 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C22CA70C;
        Wed,  2 Mar 2022 07:03:23 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id F07C868AFE; Wed,  2 Mar 2022 16:03:19 +0100 (CET)
Date:   Wed, 2 Mar 2022 16:03:19 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: move more work to disk_release v2
Message-ID: <20220302150319.GA30076@lst.de>
References: <20220227172144.508118-1-hch@lst.de> <741e087a-43f8-dc90-b679-7865cf503ac3@acm.org> <20220301125632.GA3911@lst.de> <c61b6a0d-c3b5-30e2-14c5-efa7ea475c23@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c61b6a0d-c3b5-30e2-14c5-efa7ea475c23@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 01, 2022 at 09:05:24PM -0800, Bart Van Assche wrote:
> Hmm ... even with that patch applied, I still see the crash reported in my 
> previous email. After I observed that crash I did a clean kernel build to 
> make sure that the kernel binaries used in my test match the source code.

I still can't reproduce it at all.  With this patchset on Jens'
for-5.18/block branch I do get a pre-existing crash in
nvmf_connect_admin_queue, and on Jens' for-next tree that has all the
latest fixes from Linus' tree I only see the CM lockdep warning you
reported.

FYI, this is a branch with the patches applied ontop of the for-next
branch:

http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/freeze-for-next
