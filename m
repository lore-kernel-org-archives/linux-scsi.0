Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C9CC05027
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 17:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjCNRNs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Mar 2023 13:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjCNRNd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2023 13:13:33 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52E4A54DB;
        Tue, 14 Mar 2023 10:13:25 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5220A68B05; Tue, 14 Mar 2023 18:13:22 +0100 (CET)
Date:   Tue, 14 Mar 2023 18:13:22 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v4 09/18] nvme: Move pr code to it's own file
Message-ID: <20230314171322.GE6780@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com> <20230224174502.321490-10-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224174502.321490-10-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +++ b/drivers/nvme/host/pr.c
> @@ -0,0 +1,155 @@
> +// SPDX-License-Identifier: GPL-2.0

I'd feel much more comfortable if we had a copyright notice code
here.  This code was written by Keith, maybe he can help to fill
in what the proper notice should be?

Otherwise this looks good to me.
