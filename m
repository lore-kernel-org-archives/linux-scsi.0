Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A88CCA473
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 15:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355435AbiFAP0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 11:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355408AbiFAP0s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 11:26:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BE72DE7
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2022 08:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XH7ph/aHPIGPAz/ZOcFvweC5cM
        r7Jn1O3nxa8RBg8+r8rX48rsUE8q9JMY0AgIiPkKt56EigtdV5D5sQr6UTPplPBs3uXhUGmSDnyZY
        NVG+vEMFvLfYDGKs+ASzhxa0y+IEOkSEp8sV0xHXqFvBgkp/1HaoihWKAKqEcqVo7xfFleF2sU8zb
        fRvT30I8v5zNRmksFkuKASz9NPNJpsBaf03ByBQBub/d15ptvZTTC4GBWg1Lx+rmKyJ2jkZMj5j3x
        vKmlfgHX79QpMyHoV7EV7nphYjKDiu7LH7v2me08oIJuH8yUomZaxBRzDhfJEEU2cO7244iZQy0dJ
        6967NavA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwQFC-00Gsos-Vq; Wed, 01 Jun 2022 15:26:47 +0000
Date:   Wed, 1 Jun 2022 08:26:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH v3 2/2] scsi: sd_zbc: prevent zone information memory leak
Message-ID: <YpeFNhJR2lOH/8rb@infradead.org>
References: <20220601062544.905141-1-damien.lemoal@opensource.wdc.com>
 <20220601062544.905141-3-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601062544.905141-3-damien.lemoal@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

