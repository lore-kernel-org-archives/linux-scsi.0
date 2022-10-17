Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A90C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 07:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiJQHjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 03:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiJQHjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 03:39:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0012E5A887;
        Mon, 17 Oct 2022 00:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oKxcyUshVyz5Bo1go72h3CZP0x
        4Oexus/HKGWeflNJlmgARYPB6wX51v3QhaAc6slKjVuiWhj/lXKvyyEiBpkS8aSrBiEWTf0owB77L
        ZOTEESpwG7/8h1+5XeYoYTmUI0TWFJ2s3Ztcf9t71+WWsavyAsDpCy2fhErOw9MTvA40JCQKdp3fN
        GbtzhR3ADrIKzHskVVP8QtwCiHnNL+DFAuJ1BJLocPiCGFBAy5MxHUs/JzTs+q3IjUCNNY+kboxz/
        cP/r58KGCKuBPzq1CEGUNw611eCQErUH4j4MRjS2+GQdXd8TOjDQ717Hp++MsAN9OO+cRjEWiuGkQ
        GnaABz9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okKiK-008VDk-2i; Mon, 17 Oct 2022 07:39:08 +0000
Date:   Mon, 17 Oct 2022 00:39:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2 2/5] scsi: target: core: Use RTPI from target port
Message-ID: <Y00GnF4E9yTvAAOZ@infradead.org>
References: <20221006105057.30184-1-d.bogdanov@yadro.com>
 <20221006105057.30184-3-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006105057.30184-3-d.bogdanov@yadro.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
