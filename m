Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B697AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 09:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C9BD61207
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 09:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhKKJ7W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 04:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhKKJ7T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 04:59:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423C5C061766;
        Thu, 11 Nov 2021 01:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=RsSgJgagNb5vMRz3sTRFwww+fy
        sKq2ufkyjijlspF/Q/Iy6iH1NDqjSVGS60gAsZ16lB1CyDORUQDkWe/HwFLh6s+BGaYYTasT8wP9R
        d7E18xN2pU4eY1nPLdzoskaxWw40lQonZSa9uC6lWSbEQWN1603w4afRc4RcxOjmyHTEQgsN7o9vs
        NJNr6wlhsBbta9OKuQr0yEldW98xJyvbFODz740zQr/lDERIHJFMx9U7G46lcHAdmKK5PydCLUC6M
        f7xPw5NvaZTuiEPuHEaROYNlx+QMR7vnS3EIea+sGZm+DexnhLL3+dCBUcdKcPlj8JpVvhhG7zEr0
        vFvaHBIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml6on-007dMW-KU; Thu, 11 Nov 2021 09:56:29 +0000
Date:   Thu, 11 Nov 2021 01:56:29 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: fix scsi device attributes registration
Message-ID: <YYzozVs+rGBDpCWo@infradead.org>
References: <20211111084551.446548-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111084551.446548-1-damien.lemoal@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
