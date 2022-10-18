Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3DAC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 15:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJRPQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 11:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJRPQy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 11:16:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15D586F98;
        Tue, 18 Oct 2022 08:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DAF44CE1E55;
        Tue, 18 Oct 2022 15:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C047C433D6;
        Tue, 18 Oct 2022 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666106210;
        bh=Jojqx8JmIXM8eX+9+/gLAMgo92LjQnmaGRkIZSiWd0E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XPjinHnLX6amH9fmO1CVFvKAW++ZJ7bxjK1h8STCygeyFBEkM3lTNO6VdZc8No5oD
         o4cv2fILT7O6tBsgp8+0CDpoHgk8pLVF6VtOOV0ZS9WF8cWDR63cOA9EB/YMHi2l9b
         vHYFGplWUR5l8pGcIBoinfAkKeWm8IBXKd9trGAqmYCG88PCUZDbZIOKmiiP7ahVGJ
         BnJqaFRIMRlV9DQnjNej1YvN5IpXK3Y48QgMsmMJAAktcwt4lfGt3NVSb7b9cH+/kp
         ROAac6dg+n2qqjSHUiBAbl9eKe8Uk/ahT1AAPBacyPyrCfHWW/0gYADoNUtAK9JNt5
         nmy8nDM9xskBg==
Date:   Tue, 18 Oct 2022 09:16:46 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: don't drop the queue reference in blk_mq_destroy_queue
Message-ID: <Y07DXuShbjGx1a8x@kbusch-mbp.dhcp.thefacebook.com>
References: <20221018135720.670094-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018135720.670094-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Series looks good to me.

Reviewed-by: Keith Busch <kbusch@kernel.org>
