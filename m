Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53895C61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 05:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjCOFks (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 01:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjCOFkr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 01:40:47 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD4D43470;
        Tue, 14 Mar 2023 22:40:46 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B552268AA6; Wed, 15 Mar 2023 06:40:42 +0100 (CET)
Date:   Wed, 15 Mar 2023 06:40:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, bvanassche@acm.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v4 07/18] nvme: Fix reservation status related structs
Message-ID: <20230315054042.GA29433@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com> <20230224174502.321490-8-michael.christie@oracle.com> <20230314171538.GG6780@lst.de> <c9082d55-7009-279a-fde1-7f774fb7e6e8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9082d55-7009-279a-fde1-7f774fb7e6e8@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 14, 2023 at 05:23:16PM -0500, Mike Christie wrote:
> We could do separate structs though:

I suspect that's probably better in the long run, as the [0] notation
is on its way out.
