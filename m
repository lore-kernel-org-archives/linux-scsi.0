Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB05C83005
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 08:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239043AbjFGIRz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjFGIRx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 04:17:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8511138;
        Wed,  7 Jun 2023 01:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DCD663313;
        Wed,  7 Jun 2023 08:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE0EC433EF;
        Wed,  7 Jun 2023 08:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686125871;
        bh=FLHaJwurOdg3CBBPpURcf+GsCLNx/2nTjrvXvxslLqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dz/r7loUmnTb2g2EAC3T7ceavY7IwvhOHPGEEibcPUxsJY6KC2gmPe0xcRQR21aSh
         olNDRKGuFSzVioAzLk1NChq/3z0NHm7Vb8vDNkiK+B7kEoqXVHZwbQsQb9GUVyxUve
         RId/Cr+X/EOu48m38E7bB05/uF21WKLwVvjG/co6Q0PlSjZO+rmoiwML2uoHT9cxWD
         1OqT9nE1/AKE9YWl0HRujjE29nTi5g5d0aWLmzBEbBGhWdue4NjhPdeUakeYnOt+OC
         WcNS0IQ/wY/XXkxplaeUBP2bDHV6G7BmhuQEPFAa5t9BmeAND50lnrKW69F6SPoN06
         nNrInpX+dlUDQ==
Date:   Wed, 7 Jun 2023 10:17:38 +0200
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
Subject: Re: [PATCH 04/31] cdrom: remove the unused cdrom_close_write release
 code
Message-ID: <20230607-rappen-balken-59ec17f7f4be@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 06, 2023 at 09:39:23AM +0200, Christoph Hellwig wrote:
> cdrom_close_write is empty, and the for_data flag it is keyed off is
> never set.  Remove all this clutter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
