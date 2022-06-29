Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1DFCCA47F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 05:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiF2Fkd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 01:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiF2Fkc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 01:40:32 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FD224F0D;
        Tue, 28 Jun 2022 22:40:31 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1586067373; Wed, 29 Jun 2022 07:40:28 +0200 (CEST)
Date:   Wed, 29 Jun 2022 07:40:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>, hch@lst.de,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, iommu@lists.linux-foundation.org,
        iommu@lists.linux.dev, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com, joro@8bytes.org, will@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        m.szyprowski@samsung.com, robin.murphy@arm.com
Subject: Re: [PATCH v4 5/5] libata-scsi: Cap ata_device->max_sectors
 according to shost->max_sectors
Message-ID: <20220629054027.GB16297@lst.de>
References: <1656343521-62897-1-git-send-email-john.garry@huawei.com> <1656343521-62897-6-git-send-email-john.garry@huawei.com> <b69c6112-98b7-3890-9d11-bb321a7c877a@opensource.wdc.com> <6619638c-52e8-cb67-c56c-9c9d38c18161@huawei.com> <ba59a0da-a982-e3eb-1cb7-6e60f80fd319@opensource.wdc.com> <38ae1cc8-1411-bb54-e082-0f7b91cb9e63@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38ae1cc8-1411-bb54-e082-0f7b91cb9e63@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 28, 2022 at 12:33:58PM +0100, John Garry wrote:
> Well Christoph originally offered to take this series via the dma-mapping 
> tree.
>
> @Christoph, is that still ok with you? If so, would you rather I send this 
> libata patch separately?

The offer still stands, and I don't really care where the libata
patch is routed.  Just tell me what you prefer.
