Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B766AC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9722F60200
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238157AbhHJI2e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 04:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238156AbhHJI23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 04:28:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE88C0613D3;
        Tue, 10 Aug 2021 01:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fVKAeIMVwAZMzmQ7IqkAvnME65o8G8Gng5rzUVKAv3M=; b=Dt0Vij3rk6h2ordx3QvOv5zd9T
        RN/ig+stR9p3GrylQePOcoLZIXFnr4UGMu+Tm87avD8P2O21NqW31++2NlL3nGE23TKy7n0BdKZ/0
        cGNsnATu5mU12a6WDZyVXsfnqhJ+p/2zQYEtQjUmSrVaZ8lL3DqhQ8PnXpyve4mSep1rTuCjr/g1y
        whUXX/JLmV1ECEbWkvP59WO1veJKMxzQHFo3Ofh+kSJZedZz8HXs7y9Z/TNnbv0/Oxdqc1Tsi4a1y
        PR1EO6+D72+W1eRZLPZZbQ6rneeJl9K11YFoAHLyph9QJpTecdRQvuCO88Yt82oI5BVahHVsO0+3G
        SvsomyRA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDN6l-00BtML-4M; Tue, 10 Aug 2021 08:27:47 +0000
Date:   Tue, 10 Aug 2021 09:27:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 4/4] doc: document sysfs queue/cranges attributes
Message-ID: <YRI4d39W1LMov/UZ@infradead.org>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-5-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726013806.84815-5-damien.lemoal@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 26, 2021 at 10:38:06AM +0900, Damien Le Moal wrote:
> Update the file Documentation/block/queue-sysfs.rst to add a description
> of a device queue sysfs entries related to concurrent sector ranges
> (e.g. concurrent positioning ranges for multi-actuator hard-disks).
> 
> While at it, also fix a typo in this file introduction paragraph.

That should really be a separate patch.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
