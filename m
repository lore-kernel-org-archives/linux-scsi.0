Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DFECCA479
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 05:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244201AbiF1FEC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 01:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243870AbiF1FEB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 01:04:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FF8DE87;
        Mon, 27 Jun 2022 22:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=l+MgMv3L3bgCrkqtUqCjJub9dL
        YqBSiG9e8iPw/X97UIRqUBvx/HUaf7AdSANrPDsTgQxnRlCneGMvrF2c+FGPt6WglWhREbNu4IUJx
        dpBybecfnXDIWvmfkzRvlkiQEgXq133MofQgqXIf6VUfN4JNWkUQyhUMJkbfFVpoIbYH37mmRt4vr
        jLksV32vxn48cEiGWuw6jz5KfctFTEUV3ium3GtzIxWWft8D1diiodWd0c5Ruy2Qxn1crQOir7W6G
        mCtBb0xehbkQPTVPdsyEY6ywaGoJlXwHRWjTQtgZZAfdJqSvsTAIi8ktwEtLzCe2if+7dJ3IyJjFm
        2Se+bjOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o63OJ-004JDZ-PX; Tue, 28 Jun 2022 05:03:59 +0000
Date:   Mon, 27 Jun 2022 22:03:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 3/5] scsi: target: Add iblock configure_unmap callout
Message-ID: <YrqLv+ze94TXYcVH@infradead.org>
References: <20220628022953.20948-1-michael.christie@oracle.com>
 <20220628022953.20948-4-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628022953.20948-4-michael.christie@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
