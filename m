Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2E6C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 19:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02BF36120A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 19:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236349AbhGLTfT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 15:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbhGLTfT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 15:35:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCECC0613DD;
        Mon, 12 Jul 2021 12:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5tfDk/JajaRHsi4tzH2fGSvumh37Jv1UygOEKTBXISw=; b=YJVDW8s0FfHwVeWCVLbYMWnSs1
        N0DaXsDXMIxxjd/qlHW04NpLQ/Zf86KJKG0b1DMkcj0OmPhFnQ8C3JXU7bdoxaWHczsL4Ue771QJA
        0/8pU17Dm02QzdDINzWuAeS+5y+W+ZC2mJp0e+za5rPpNEVm7SE3rBmP4wti1M15sYJ/ZAot06aGM
        7AP9hfGoJRWo2jzGMdxQX1Y/MPfokaqViRpKowJWX6sSfx/a3PqUR2LpFMrPCeInu5zYo9A6sXJJ5
        /fMYzoqrllhgdrSJ4iskx2vvCPTbeI+aVNiG4LKwPCQosJzN3xGRGkFujuq5rFUMtpJirEPbJGIwV
        2/3QO6Xg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m31ep-000NIm-KH; Mon, 12 Jul 2021 19:32:10 +0000
Date:   Mon, 12 Jul 2021 20:31:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] sd: don't mess with SD_MINORS for
 CONFIG_DEBUG_BLOCK_EXT_DEVT
Message-ID: <YOyYrybhQss64aFg@infradead.org>
References: <20210712155001.125632-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712155001.125632-1-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 12, 2021 at 05:50:01PM +0200, Christoph Hellwig wrote:
> No need to give up the original sd minor even with this option,
> and if we did we'd also need to fix the number of minors for
> this configuration to actually work.

Linus just picked this up directly.
