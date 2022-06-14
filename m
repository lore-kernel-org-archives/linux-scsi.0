Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68A6C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 06:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238510AbiFNGnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 02:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352254AbiFNGnJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 02:43:09 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2920638D87;
        Mon, 13 Jun 2022 23:43:09 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BE14568AA6; Tue, 14 Jun 2022 08:43:03 +0200 (CEST)
Date:   Tue, 14 Jun 2022 08:43:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com, brking@us.ibm.com,
        hare@suse.de, hch@lst.de, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, chenxiang66@hisilicon.com
Subject: Re: [PATCH RFC v2 01/18] blk-mq: Add a flag for reserved requests
Message-ID: <20220614064303.GA31683@lst.de>
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com> <1654770559-101375-2-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1654770559-101375-2-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 09, 2022 at 06:29:02PM +0800, John Garry wrote:
> Add a flag for reserved requests so that drivers may know this for any
> special handling.
> 
> The 'reserved' argument in blk_mq_ops.timeout callback could now be
> replaced by using this flag.

And we should probably do that ASAP, independent of the rest of this
series.  Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
