Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8540CC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 22 May 2022 13:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238868AbiEVNNy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 May 2022 09:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiEVNNw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 May 2022 09:13:52 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61882CE25;
        Sun, 22 May 2022 06:13:50 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 24ACF68AFE; Sun, 22 May 2022 15:13:46 +0200 (CEST)
Date:   Sun, 22 May 2022 15:13:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     damien.lemoal@opensource.wdc.com, joro@8bytes.org, will@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, liyihang6@hisilicon.com,
        chenxiang66@hisilicon.com, thunder.leizhen@huawei.com
Subject: Re: [PATCH 0/4] DMA mapping changes for SCSI core
Message-ID: <20220522131345.GB25785@lst.de>
References: <1653035003-70312-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1653035003-70312-1-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The whole series looks fine to me.  I'll happily queue it up in the
dma-mapping tree if the SCSI and ATA maintainers are ok with that.

