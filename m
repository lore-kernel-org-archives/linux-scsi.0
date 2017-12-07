From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/2] Ensure that the SCSI error handler gets woken up
Date: Wed, 06 Dec 2017 20:55:19 -0500
Message-ID: <yq1o9nbxpx4.fsf@oracle.com>
References: <20171204180624.18722-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdLGB4H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2017 20:56:07 -0500
In-Reply-To: <20171204180624.18722-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Mon, 4 Dec 2017 10:06:22 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org


Bart,

> As reported by Pavel Tikhomirov it can happen that the SCSI error
> handler does not get woken up. This is very annoying because it
> results in a queue stall. The two patches in this series address this
> issue without acquiring the SCSI host lock in the hot path. Please
> consider these patches for kernel v4.16.

Applied to 4.16/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
