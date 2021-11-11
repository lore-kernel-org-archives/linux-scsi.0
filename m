Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32873C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1496761284
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhKKHTA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 02:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhKKHS7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 02:18:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1E7C061766;
        Wed, 10 Nov 2021 23:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DkBYzo5hVd+Np4U1+AeHk1AqSsI5dOsaW8Yrru+jpAQ=; b=nLAE0+V3a7UdIJ4P2DXBdK3iMI
        Qp8m9Zfj70ADzwnirXXkkJjghC0kfrBao7sCAnV8tHbRhGeGginMtsU6Yq9918z0qk+ZWFy0hr2hY
        sNYLx7udTawF7qH7XYcvhzalpKLgrz+1YdNMUT1+jEExGMGAX7h6kPU+LkzZ1Ew2dKNW+u+ebbenc
        CH5phwhIoykhxoPur14CvB+7i+NVt6/rKJbKKIb7S5E6GinrOB2en3Cmowaf9J5x5wnSRCAQC7YRl
        33r+FbNnmFrCdLQD4WBRXdfR+CHANliScS7iFzexWmp6/h5nPr06DFBCjPL6rtj0U0u8tpg5kzlpg
        0zmWVM5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml4Je-007MAE-Jr; Thu, 11 Nov 2021 07:16:10 +0000
Date:   Wed, 10 Nov 2021 23:16:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] libata: libahci: declare ahci_shost_attr_group as static
Message-ID: <YYzDOlhidXy4IlMK@infradead.org>
References: <20211111033430.296597-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111033430.296597-1-damien.lemoal@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 11, 2021 at 12:34:30PM +0900, Damien Le Moal wrote:
> ahci_shost_attr_group is referenced only in drivers/ata/libahci.c.
> Declare it as static.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
