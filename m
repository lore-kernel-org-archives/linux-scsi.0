Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472F0C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ED6420714
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="syS4O3nE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgC0RVn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:21:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53042 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgC0RVn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 13:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2IRZtTmoy6NBNTpxrAxkZSCYgY7hHuL0Uziesh0AoA0=; b=syS4O3nETDjllKG0pvkFmncTJ6
        /gd6P76HBoPfB5kjWylRrX4onzHzQyFtH2Gq+1VJeIkvUujAypwuK1nZkjVfUzjcFRtVJp/V6XPcF
        qqDX31Ha/eEIpYT3AVZRgaRtbAwwm/wfkN6WSIOL1AgGviZgibenAq8ZF6S0urC0CC4RF8VMEHYJX
        QmucFCwUGymfL2DewLQ3twvGzIkOIwAkKfF6Ef7LabcHEQJH6lTVkPi72GdAQRsAU39fIImDIDoG2
        ABj+5xUl1XOr3NCzSSLvhnmlAyWXM9vDazoeMFJpzKxjmVULpcZvzZJLnj1g+khd9SAHhnlHSKoyW
        aPzlghFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHsfu-0005PO-5g; Fri, 27 Mar 2020 17:21:42 +0000
Date:   Fri, 27 Mar 2020 10:21:42 -0700
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
Subject: Re: [PATCH v3 05/10] scsi: sd_zbc: factor out sanity checks for
 zoned commands
Message-ID: <20200327172142.GG11524@infradead.org>
References: <20200327165012.34443-1-johannes.thumshirn@wdc.com>
 <20200327165012.34443-6-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327165012.34443-6-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Mar 28, 2020 at 01:50:07AM +0900, Johannes Thumshirn wrote:
> Factor sanity checks for zoned commands from sd_zbc_setup_zone_mgmt_cmnd().
> 
> This will help with the introduction of an emulated ZONE_APPEND command.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
