From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: set host_byte to DID_REQUEUE when ocs = OCS_ABORTED
Date: Tue, 27 Jun 2017 21:34:28 -0400
Message-ID: <yq17ezwzyhn.fsf@oracle.com>
References: <20170624102722.4050-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26020 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752694AbdF1Bfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2017 21:35:40 -0400
In-Reply-To: <20170624102722.4050-1-zangleigang@hisilicon.com> (Zang Leigang's
        message of "Sat, 24 Jun 2017 18:27:22 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Zang Leigang <zangleigang@hisilicon.com>


> Host set ocs to OCS_ABORTED when clear a doorbell in err handler.
> Then scsi_decide_disposition return SUCCESS. This may cause some
> filesystem panic because a FAILED REQUESET. Requeue and complete is
> better.

Subhash: Please review the three ufs patches from Zang.

https://patchwork.kernel.org/patch/9807763/
https://patchwork.kernel.org/patch/9807759/
https://patchwork.kernel.org/patch/9807755/

-- 
Martin K. Petersen	Oracle Linux Engineering
