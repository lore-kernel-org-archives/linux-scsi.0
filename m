Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF712C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 07:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiJQHjz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 03:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiJQHjm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 03:39:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7B110FEE;
        Mon, 17 Oct 2022 00:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YY8r9ii7OVCEOqDph20DfcQ/gV
        Z4zKTWEncyswp+CVFsQopjTwaCkDTNrFH7gucruOQiWFvLGAS3RuDktuUEQCg5UX64y4/dMLmGDLy
        XkstGwAWM+IEC9mHM0gmDRqYhQbK6N2PhryKQtHNSM+PlWaw2d28JC3Q1PEqZcTUIefNgJy+mtzES
        UQ1OUNRN0uZGov8Tn9u+7cJRUt7eLFFUW7yEOGmI/6RiZ6jPXacD7HC7kE53hB7tLoRM83NDivgN7
        Zm1FLzF3/ci6PCV/p49tHzcY3ZaGRg5nd/BcWKe+u4PHcQ7sxV9Nr3N1J1Trx9Uxs7VLBeYsKJjkE
        6BFTY4cA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okKik-008VbB-3L; Mon, 17 Oct 2022 07:39:34 +0000
Date:   Mon, 17 Oct 2022 00:39:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2 3/5] scsi: target: core: Drop device-based RTPI
Message-ID: <Y00Gtm76Q+LgSaEL@infradead.org>
References: <20221006105057.30184-1-d.bogdanov@yadro.com>
 <20221006105057.30184-4-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006105057.30184-4-d.bogdanov@yadro.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
