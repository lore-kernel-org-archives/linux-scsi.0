From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mac_esp: fix to pass correct device identity to free_irq()
Date: Wed, 26 Apr 2017 18:31:53 -0400
Message-ID: <yq160hqajhi.fsf@oracle.com>
References: <20170425030845.7809-1-weiyj.lk@gmail.com>
        <alpine.LNX.2.00.1704261540340.26898@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42183 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031615AbdDZWcG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 18:32:06 -0400
In-Reply-To: <alpine.LNX.2.00.1704261540340.26898@nippy.intranet> (Finn
        Thain's message of "Wed, 26 Apr 2017 15:43:59 +1000 (AEST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org


Finn,

> free_irq() expects the same device identity that was passed to
> corresponding request_irq(), otherwise the IRQ is not freed.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
