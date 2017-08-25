From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/17] A series of small SCSI patches for kernel v4.14
Date: Fri, 25 Aug 2017 17:09:24 -0400
Message-ID: <yq1efrz73sr.fsf@oracle.com>
References: <20170825204643.25043-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42772 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758720AbdHYVJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 17:09:30 -0400
In-Reply-To: <20170825204643.25043-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Fri, 25 Aug 2017 13:46:26 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org


Bart,

> The patches in this series fall into three categories:
> - One patch renames a few functions to make it clear whether these
>   are used by the legacy SCSI code path or by the new scsi-mq code.
> - Two patches are related to using blk_mq_rq_to_pdu() instead of
>   struct request.special.
> - Fourteen patches suppress warnings reported by static analysis
>   tools. These tools are very useful but unfortunately the current
>   code base makes these tools report a significant number of false
>   positives.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
