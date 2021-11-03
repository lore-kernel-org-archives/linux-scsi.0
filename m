Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B4DC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 495166112E
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhKCRn7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhKCRn6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:43:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47071C061714;
        Wed,  3 Nov 2021 10:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Nf6zVa2oCcsZyM8BKLppSX770p+0nEqOT17MYVcAujo=; b=NemGOUnskqTSSj1I9TIaTg7pRu
        bghyAuZ7FUYA25pOlE+9XktIghK/Cg0/3qrumwOCrwsPx07eMEgYX8TWT9pYtXtze6kq6Wo5nkp/W
        yjW/IkJNOdKTsMnIXpBKeCr8zBhIWsWVWtbDk/QDlY9b6Pk58w/KxmLStAwwLgYvHGm19v3iagQwD
        eHqrLle1ZPT2LbKprtC0Q1zSvx+xDUpsIpYi0u5lxqHGCvIumUi/zcmzMfWhliKNakexnHg6ZfXXH
        ShQL2SNIA9wIQxphHr0a4DpSTWNBgpcMJHi2CHyDP8aliewz7DBYdBkg48yL60dP+SVRnzkKrGVF3
        gTzgt1JQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKG7-005yXB-2L; Wed, 03 Nov 2021 17:41:11 +0000
Date:   Wed, 3 Nov 2021 10:41:11 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org
Cc:     linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/13] block: add_disk() error handling stragglers
Message-ID: <YYLJt8qkHccpTycn@bombadil.infradead.org>
References: <20211103122157.1215783-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103122157.1215783-1-mcgrof@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 05:21:44AM -0700, Luis Chamberlain wrote:
> This is the last pending changes to address add_disk() error handling
> completely. Changes on this v2 series:
> 
>   o dropped all patches which folks have said they'd pick up on their
>     own trees or that I already see present on linux-next
>   o rebased onto next-20211103
>   o Added Reviewed-by tag by Dan Williams and addressed his recommended
>     changes.
>   o Re-added the nvdimm/blk changes given Dan Williams was not able to
>     remove the driver in time for v5.16
>   o Added new nvdimm/pmem driver changes, not sure how I missed addressing
>     this before.
>   o Just note that I keep Tetsuo Handa's patch in this series as it is
>     a requirement for the __register_blkdev() changes.

I'll just send a v3 series which collects all reviewed-by tags and with
the updates.

  Luis
