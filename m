Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC63C8300C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 09:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239540AbjFGJEQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 05:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238561AbjFGJDt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 05:03:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600341BDA;
        Wed,  7 Jun 2023 02:02:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 372D2615D2;
        Wed,  7 Jun 2023 09:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C307C4339B;
        Wed,  7 Jun 2023 09:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686128540;
        bh=F5yK/CebQYGivXkJ/hRkJ11KpKZaKc+G+VOQffjNVTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sAfQXO5SH40rCtDhbwEvXcSBRhslBvNvKUU+/C6zJmUW7rk4KDZem+SyB7w55qX2y
         S8GP7XOz+Sh1JsNAkUh/43kCDhRagfGOJ6ymJTvy8EvYu8/Y72NkSvyaxeGEoX5NYg
         ZNDcw7HYM0UpR6uCZuSvmtx8nAL3oOFkFGjtbLip/0jPFzG0EsuCrfGiU3+dsUo6Mk
         09/Q8RacrQEXGw7OpkFy06YCu5mCCT4iywdTjXjWEe2cbi2/c6/h5WqzuX58R/oEbv
         wLB23zogewfEPk6rfCC+XUbaeVedBS79aJPk4vzv1kQ3/T/szT3pO6l5YM/nxQqSRl
         uTtUOEbNKxpzw==
Date:   Wed, 7 Jun 2023 11:02:12 +0200
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
Subject: Re: [PATCH 25/31] ubd: remove commented out code in ubd_open
Message-ID: <20230607-mietpreis-deich-90ec6cba9ca8@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-26-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-26-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 06, 2023 at 09:39:44AM +0200, Christoph Hellwig wrote:
> This code has been dead forever, make sure it doesn't show up in code
> searches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
