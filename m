From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: zero per-cmd private driver data for each MQ I/O
Date: Thu, 18 May 2017 21:45:24 -0400
Message-ID: <yq18tlt4o23.fsf@oracle.com>
References: <1495147205-28778-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47777 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755450AbdESBqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2017 21:46:21 -0400
In-Reply-To: <1495147205-28778-1-git-send-email-longli@exchange.microsoft.com>
        (Long Li's message of "Thu, 18 May 2017 15:40:05 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Long Li <longli@exchange.microsoft.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, KY Srinivasan <kys@microsoft.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Stephen Hemminger <sthemmin@microsoft.com>, Long Li <longli@microsoft.com>, stable@vger.kernel.org


Long,

> In lower layer driver's (LLD) scsi_host_template, the driver may
> optionally ask SCSI to allocate its private driver memory for each
> command, by specifying cmd_size. This memory is allocated at the end
> of scsi_cmnd by SCSI.  Later when SCSI queues a command, the LLD can
> use scsi_cmd_priv to get to its private data.
>  
> Some LLD, e.g. hv_storvsc, doesn't clear its private data before
> use. In this case, the LLD may get to stale or uninitialized data in
> its private driver memory. This may result in unexpected driver and
> hardware behavior.
>
> Fix this problem by also zeroing the private driver memory before
> passing them to LLD.

Applied to 4.12/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
