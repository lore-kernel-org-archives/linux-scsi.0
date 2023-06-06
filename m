Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D71C7EE32
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jun 2023 08:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbjFFI3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jun 2023 04:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbjFFI2u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2023 04:28:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7749D1BE8;
        Tue,  6 Jun 2023 01:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE18610AA;
        Tue,  6 Jun 2023 08:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF06C433D2;
        Tue,  6 Jun 2023 08:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686040044;
        bh=Ul2cGfsXNIMiykZwhFC1GhCumtuf5drHj+O/jqIfKC8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MIGMl8H6ZE1RDdRAyTflrfjbWgwVzW92xqGaMt1JiQ4SA+mJ4HMs0LbcBMXK3XGit
         s8AH6LT5xvGT0yz9De/gwc9rycYwPfPg/PTSp4QuSkk0vOtIYZ0sGO7Zr/oqRQEn3Q
         bZTC+xvpq4ZzHyydtCd2+MUht7VjSMVAc+QW6ZPVxfiAMzISs3v9vRyYsu+gqogzM9
         HTOpqo1f7t7P4IpAfgrmShg7Yu9telb/BuewQOoAVz62LWjeBpYBAlToNuiqrKvZSi
         OO2A9iQpLezyTGvSBIIeI/aI3LzBW6+Umq+ZCMYqHmmp9Dt2Hg5qaDReScqKNzXi7c
         tDihS0qt4RtdA==
Date:   Tue, 6 Jun 2023 10:27:14 +0200
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
Subject: Re: decouple block open flags from fmode_t
Message-ID: <20230606-raumtemperatur-languste-045c5472f6a0@brauner>
References: <20230606073950.225178-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 06, 2023 at 09:39:19AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds a new blk_mode_t for block open flags instead of abusing

Trying to look at this series applied but doesn't apply cleanly for
anything v6.4-rc* related. What tree is this on?
