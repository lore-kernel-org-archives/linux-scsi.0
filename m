Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5027BC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 08:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbjFGIf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239783AbjFGIfT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 04:35:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427CB10F9;
        Wed,  7 Jun 2023 01:35:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D397A63C19;
        Wed,  7 Jun 2023 08:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9368FC433D2;
        Wed,  7 Jun 2023 08:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686126906;
        bh=DEpqJ01874Wcf6flpWQL4l3j+OyeWJJ1wSvscW2ZsvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3CH5XZi7Ku/UmN1uNhGHrNxFPQhZ8efjNfiTbNsWjKI+qjrG2GJAlxpGl4WKzZoh
         BUa3cIn0dVM3WafUAzzbH8uuNxyByYfP8H70QxdowRN6RCs5nrCwMqpAWtTtCtkrfA
         UUoFuECYuwF6g6BZvtkz1yfF3SziUWNAxmfcDv+ZyAT15huu83Xslw1FDR3OSN3f7M
         cxo76H7oplo9/nKa80/LLfizTzZ0Gzi/jSYy7ksr7BoXSBWk0n4y6gq2zZA1zoG10d
         b82jMNFwK474uaEbmhI5IxsDz3/ABjdRxN6qmozleapT3Vy9qyc29Lz62fPrh+D/W5
         4FkCLrnTGlquQ==
Date:   Wed, 7 Jun 2023 10:34:57 +0200
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
Subject: Re: [PATCH 10/31] block: remove the unused mode argument to ->release
Message-ID: <20230607-inbetriebnahme-markieren-42711df12a4b@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-11-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 06, 2023 at 09:39:29AM +0200, Christoph Hellwig wrote:
> The mode argument to the ->release block_device_operation is never used,
> so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Good cleanup. Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
