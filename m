From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hpsa: free irq on q indexed by h->intr_mode and not i
Date: Mon, 14 Nov 2016 18:36:31 -0500
Message-ID: <yq1eg2dfxc0.fsf@sermon.lab.mkp.net>
References: <20161114125935.12158-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19993 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754630AbcKNXgp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2016 18:36:45 -0500
In-Reply-To: <20161114125935.12158-1-colin.king@canonical.com> (Colin King's
        message of "Mon, 14 Nov 2016 12:59:35 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin> From: Colin Ian King <colin.king@canonical.com> Use correct index
Colin> on q, use h->intr_mode instead of i. Issue detected using static
Colin> analysis with cppcheck

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
