Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E83FA373D
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Oct 2022 08:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJ3IS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Oct 2022 04:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiJ3IS4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Oct 2022 04:18:56 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8729633E;
        Sun, 30 Oct 2022 01:18:55 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3CC2A68AA6; Sun, 30 Oct 2022 09:18:52 +0100 (CET)
Date:   Sun, 30 Oct 2022 09:18:51 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v3 11/19] nvme: Add pr_ops read_reservation support
Message-ID: <20221030081851.GB4774@lst.de>
References: <20221026231945.6609-1-michael.christie@oracle.com> <20221026231945.6609-12-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026231945.6609-12-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +	memset(resv, 0, sizeof(*resv));

Is there any good reason this isn't done by the caller?
