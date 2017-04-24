From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mvumi: remove code handling zero scsi_sg_count(scmd) case
Date: Mon, 24 Apr 2017 18:17:18 -0400
Message-ID: <yq137cxih75.fsf@oracle.com>
References: <1492988460-453-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50757 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978741AbdDXWSD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 18:18:03 -0400
In-Reply-To: <1492988460-453-1-git-send-email-khoroshilov@ispras.ru> (Alexey
        Khoroshilov's message of "Mon, 24 Apr 2017 02:01:00 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org


Alexey,

> As Christoph Hellwig noted, SCSI commands that transfer data
> always have a SG entry. The patch removes dead code in
> mvumi_make_sgl(),  mvumi_complete_cmd() and mvumi_timed_out()
> that handle zero scsi_sg_count(scmd) case.
>
> Also the patch adds pci_unmap_sg() on failure path in mvumi_make_sgl().

Applied to 4.12/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
