From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: ufs: fix error return code in ufshcd_init()
Date: Thu, 29 Sep 2016 21:38:30 -0400
Message-ID: <yq18tuaw4ix.fsf@sermon.lab.mkp.net>
References: <1475074182-13038-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51570 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935230AbcI3Bim (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2016 21:38:42 -0400
In-Reply-To: <1475074182-13038-1-git-send-email-weiyj.lk@gmail.com> (Wei
        Yongjun's message of "Wed, 28 Sep 2016 14:49:42 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org

>>>>> "Wei" == Wei Yongjun <weiyj.lk@gmail.com> writes:

Wei> Fix to return a negative error code from the error handling case
Wei> instead of 0, as done elsewhere in this function.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
