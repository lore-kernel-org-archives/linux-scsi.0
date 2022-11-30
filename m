Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 608F5C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 10:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbiK3KCy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbiK3KCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 05:02:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB937673
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 02:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EoTySK9J9mK0JSSX947on8PHo5OuW7fUsGCv+ryHvfU=; b=wFjS9XN2amT9L31vEV/M/oWgJ5
        NLLRQM6mFHGiU9y18MiHODOSu+r2FwSxWrd3bsnLxcz4qiZi1RZk3V+Rf41zh9N1C5jOq60qaLCYI
        ueVC4zzry6o7uWTtSXxIfuG06c+clJPtS3wJfSyOIJvkP3QJScTaXImhf4aaLMjxQiOnl4Uxt6Ma7
        gXgYmhL8/oENjLMfyUrjf4k/8krWC8awcg/SubaoNqJ4SBOc/A+43ZTpy/An/e9vPAJOFwz6fpuF8
        u6AFwZbCjZatN/jfMnzx10U/9/i0bilDzYk5GBA1RjwcnB4C/P6hwjKVjVVsw17gx7JgysQkUhi1W
        tdEg7zfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0JvV-00FJ7r-50; Wed, 30 Nov 2022 10:02:49 +0000
Date:   Wed, 30 Nov 2022 02:02:49 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Message-ID: <Y4cqSUo7wcnzLLcj@infradead.org>
References: <39540065afb936255236311fc6c93f67a7805bf6.1669797508.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39540065afb936255236311fc6c93f67a7805bf6.1669797508.git.johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 30, 2022 at 12:39:21AM -0800, Johannes Thumshirn wrote:
> +EXPORT_SYMBOL(scsi_trace_parse_cdb);

Unless I'm missing something you don't actually use this anywhere.
