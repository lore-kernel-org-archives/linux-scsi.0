From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] storvsc: remove bogus code to transfer struct scatterlist
Date: Tue, 31 Jan 2017 21:49:43 -0500
Message-ID: <yq11svi1v7c.fsf@oracle.com>
References: <1485681138-21236-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38435 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdBACt5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2017 21:49:57 -0500
In-Reply-To: <1485681138-21236-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Sun, 29 Jan 2017 10:12:18 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Remove a piece of code in storvsc_queuecommand that tries to
Christoph> pass the physical address of the kernel struct scatterlist
Christoph> pointer to the host.

Christoph> Fortunately the code can't ever be reached anyway.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
