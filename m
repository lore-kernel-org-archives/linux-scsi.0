Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD66C352A1
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 10:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiK3KBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbiK3KBP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 05:01:15 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6090A2FA44
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 02:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fIM94jXZOHuG9CoTLxjv99oX3CjMUeCVdSnk87jZago=; b=wvqHGAchN1HAF5l2VKkQO6JcfE
        ufCQDGcLR4A3b71YoHCsRdp5HlvuogdGJEpp7T0/snZKKUcjE5zmci/iD9zgVnWliCNkaWeOauj2a
        y7o5Qy6srI7p9l3s9BHnwBwO5jTnceQAeXSkyR4h0HzD/B1SAFqXMvemVX2dgFH83eE18e8Zbl1+r
        mOpx7kKEiwzaLpSgAYdYslRZan8lEWo2IUJqqBDIxWBbYU1p0nhHgYCaniE5M5bgjsobu7N3oUo8S
        WY5Wujf8/QSxLhE1dVJ5NR7fRYNyU/v/0cI7nU1dGVkPxsodbBs7Y6WzcpkqS92ociY2I+HIaO/6H
        y37AcjOA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0Jtt-00FIZC-Ha; Wed, 30 Nov 2022 10:01:09 +0000
Date:   Wed, 30 Nov 2022 02:01:09 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Message-ID: <Y4cp5S4AWV7+Sw3T@infradead.org>
References: <39540065afb936255236311fc6c93f67a7805bf6.1669797508.git.johannes.thumshirn@wdc.com>
 <a60e44ec-a262-d668-4410-60518091f514@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a60e44ec-a262-d668-4410-60518091f514@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 30, 2022 at 06:59:43PM +0900, Damien Le Moal wrote:
> Why not drivers/scsi/sd_trace.h ? That would work too, no ?

Yes, that's also what I suggested previously.
