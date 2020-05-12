Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00671C54E8F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 13:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D426320730
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 13:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nZ+z39ed"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbgELNRx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 09:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729336AbgELNRx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2020 09:17:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4027CC061A0C;
        Tue, 12 May 2020 06:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ymssNFbUp36WuxgzaZQ6oJBtrBpxb0XxGghr4lKrK74=; b=nZ+z39edxptIuSfVm8WcO0L8RE
        Qr3fSrg05bH/grhHrQT8QyHiTd7uRRNaBxljPeHjO93ai4HselKheqik+h1izwJUhYoww2Vll1UhI
        7lRaEf5dg/2g0Am0kRnOEKHwu0J6X7V2rorYgdaajX+f27RFJQ875lJ33YvPq+pmbZxb3gOeQF8X0
        PGegApZ+qwtIxTHF7eE4D6IDKaehZv/j3XGNYXTFtSBxw7pjem5Gv8nmNL2y4Y336C98jezuBZZPL
        GHZk03y3q/cOyJ5JWpAdVKIhMm5wuHXegopGbhdHmszqtoRbUyfQswuJ2EFHX0epB9VBsXd0hyUK5
        xmd4xf9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYUn6-0004BP-Ma; Tue, 12 May 2020 13:17:48 +0000
Date:   Tue, 12 May 2020 06:17:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v11 00/10] Introduce Zone Append for writing to zoned
 block devices
Message-ID: <20200512131748.GA15699@infradead.org>
References: <20200512085554.26366-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512085554.26366-1-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The whole series looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I hope we can get this in 5.8 to help with the btrfs in 5.9.
