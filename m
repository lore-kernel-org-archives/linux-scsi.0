Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB491C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 05:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244761AbiF1FDq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 01:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244642AbiF1FDo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 01:03:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E372658;
        Mon, 27 Jun 2022 22:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GtxvwbLXYH2BUHqKGTMiuCKQZCqUp+BlekzgbdTlvFI=; b=PZezU5X/G1Pr8emZN5of4opgIK
        it2nQcZbSkJYaSIwQfnHwOCTd5Nu0SP/fWuk2Jr+SXbrqo4tx7XGIxwm6I1LmD6sBChydaXTnM9OC
        PMCnrh8gfv6avRuDUp9rW++cBOGpWX2UsgpFRAJCVtdezR0oh8FuMQ9y0WbpLMJtQICo60K5T4tuW
        nUcuwqlFBg6Heg/JXODVHvEh2D9WedMQ2CY/KG/I71/C5bYn1zPGY11MU0pRu/htRWPtA2FeXK6sP
        E0EfW2cd+fKEkUWew0cyJy7sdV7R0/QX76VIL5e3XknPeqLIJcGnkzSmF5vBNGiGzQJ5QTGjZuTql
        mcrp029Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o63O1-004JAR-Qf; Tue, 28 Jun 2022 05:03:41 +0000
Date:   Mon, 27 Jun 2022 22:03:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 2/5] scsi: target: Add callout to configure unmap settings
Message-ID: <YrqLrcZUGzEZjmSZ@infradead.org>
References: <20220628022953.20948-1-michael.christie@oracle.com>
 <20220628022953.20948-3-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628022953.20948-3-michael.christie@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 27, 2022 at 09:29:50PM -0500, Mike Christie wrote:
> This patch adds a callout to configure a backend's unmap settings. This
> will be used in this patchset to allow userspace to setup unmap after
> the initial device setup similar to how we can setup the other attrs
> post device configuration.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
