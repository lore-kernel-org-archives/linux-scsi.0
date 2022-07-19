Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40EB1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 04:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbiGSEGn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 00:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235670AbiGSEGl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 00:06:41 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96FC2E6AC;
        Mon, 18 Jul 2022 21:06:39 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 999A668AA6; Tue, 19 Jul 2022 06:06:35 +0200 (CEST)
Date:   Tue, 19 Jul 2022 06:06:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     damien.lemoal@opensource.wdc.com, joro@8bytes.org, will@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, iommu@lists.linux.dev,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH v6 0/6] DMA mapping changes for SCSI core
Message-ID: <20220719040635.GA26132@lst.de>
References: <1657797329-98541-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1657797329-98541-1-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks,

applied to the dma-mapping tree.
