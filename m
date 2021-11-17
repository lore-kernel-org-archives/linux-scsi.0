Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61069C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 10:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3755861B5E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 10:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbhKQKFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 05:05:14 -0500
Received: from verein.lst.de ([213.95.11.211]:49841 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236046AbhKQKEq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Nov 2021 05:04:46 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id C89DA68B05; Wed, 17 Nov 2021 11:01:42 +0100 (CET)
Date:   Wed, 17 Nov 2021 11:01:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        thomas.lendacky@amd.com, dave.hansen@intel.com
Subject: Re: [PATCH 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Message-ID: <20211117100142.GB10330@lst.de>
References: <20211116153923.196763-1-ltykernel@gmail.com> <20211116153923.196763-4-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116153923.196763-4-ltykernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This doesn't really have much to do with normal DMA mapping,
so why does this direct through the dma ops?
