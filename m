Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EE1C7EE43
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 08:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjFGIQl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbjFGIQe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 04:16:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F871702;
        Wed,  7 Jun 2023 01:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F6D763894;
        Wed,  7 Jun 2023 08:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DCEC433EF;
        Wed,  7 Jun 2023 08:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686125788;
        bh=RXb/uaqR0x5/NbgjksTcXwSkQHw+GeMJrx4xaN4v7MY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D7HLq/BSC9BMU8P4kJMjo5MRJvyXbwS4/2PvvwAgM8ZW1dL92Hwr6Zk7SS4cudd43
         YqaP0WroUvYa+J2A0NcRIinvLRsnSH3+zo1FaTyPgQ4GnhYB7qgc3d/Go72HNsVxQF
         2VnZeMObpLaXQgi8iTif/MccBCn6vLk1nxwqHzPzuxFsvOp3CDpoMGoMBUNPzKqJ+9
         MDPrw2poPrPBCR3aAKE82p3/3e6I3qqlouz4S7jup9ehDAbiUr/4WJT37Mf7snmVlY
         xWYx9JWoneLZBkWhVBZeWvh/L+gD953X7yEXsyewcrazZ0kGnjene02lhM27pPq0WM
         4vEu4pR4sz/Jw==
Date:   Wed, 7 Jun 2023 10:16:19 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>,
        Josef Bacik <josef@toxicpanda.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Coly Li <colyli@suse.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-um@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-btrfs@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 02/31] cdrom: remove the unused bdev argument to
 cdrom_open
Message-ID: <20230607-fahrdienst-leidwesen-f4192e429765@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 06, 2023 at 09:39:21AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

lgtm,
Acked-by: Christian Brauner <brauner@kernel.org>
