Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3237CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 09:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240727AbiCBJzl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 04:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbiCBJzi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 04:55:38 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A7D112B
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 01:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dDmFnIAN1SJ1gf2r4Caf1hurc0Yz9aqhis9WD9s+Z14=; b=vhiEqZ+cKHqNK19x8h9xHE8eFH
        llsGNkD4gqK5QZHB6U9wJ+bwMvpOc2bw2712JOra5ykap7o0cLTM/5D2JdqpAbZITZi8f4ay+YzIg
        wvjcv+t5QH66b+ju/SCJVRctP6mVspEMIhzO0CrM2uybOPBri3Cz4hQnOPQjJjrqTngJ00+Cwdsun
        jeESGaXM5aS8EQk8pZ2glAR73x66RaJFpLjqLIItP5gi+27dhWhk8FoixEJN0Y7iiPQDMiXsk2QwK
        20RtmA6UyX9Kmp6Rt0EamtAebxFm8kd9fniq+2ZTrVwZUCYvSSeO4QT1Z31YYeykYS3zUET1tC/qk
        HVsg6v3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPLh9-002ABp-SL; Wed, 02 Mar 2022 09:54:55 +0000
Date:   Wed, 2 Mar 2022 01:54:55 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 12/14] scsi: sd: sd_read_cpr() requires VPD pages
Message-ID: <Yh8+78IlfIb+JgWE@infradead.org>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-13-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302053559.32147-13-martin.petersen@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 02, 2022 at 12:35:57AM -0500, Martin K. Petersen wrote:
> As such it should be called inside the scsi_device_supports_vpd()
> conditional.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
