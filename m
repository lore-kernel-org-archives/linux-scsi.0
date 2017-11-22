From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi fixes for non cache-coherent architectures (for 4.15 and stable)
Date: Tue, 21 Nov 2017 23:07:17 -0500
Message-ID: <yq1bmjvklca.fsf@oracle.com>
References: <20171121132339.1702-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44267 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbdKVEHf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Nov 2017 23:07:35 -0500
In-Reply-To: <20171121132339.1702-1-hch@lst.de> (Christoph Hellwig's message
        of "Tue, 21 Nov 2017 14:23:36 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Huacai Chen <chenhc@lemote.com>, linux-scsi@vger.kernel.org, iommu@lists.linux-foundation.org


Christoph,

> this series fixes scsi and libsas operations on platforms with cache
> incoherent dma operations.  Patch 2 and 3 are originally from Huacai Chen,
> but I've modified patch two so that it doesn't require his
> dma_get_cache_alignment() rework, which I'd rather get into the next
> merge window after the required fixups, and which isn't suitable for
> a stable backport.  Patch 1 is new from me and makes sure
> dma_get_cache_alignment is always available.  As on of the dma-mapping
> maintainers I'd be happy with it going in through the scsi tree.

Applied to 4.15/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
