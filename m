Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F08C77B6F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 05:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjDKFgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 01:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjDKFgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 01:36:10 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2115626AE;
        Mon, 10 Apr 2023 22:36:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8327168BFE; Tue, 11 Apr 2023 07:36:07 +0200 (CEST)
Date:   Tue, 11 Apr 2023 07:36:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v6 16/18] scsi: target: Pass struct
 target_opcode_descriptor to enabled
Message-ID: <20230411053607.GF17645@lst.de>
References: <20230407200551.12660-1-michael.christie@oracle.com> <20230407200551.12660-17-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407200551.12660-17-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
