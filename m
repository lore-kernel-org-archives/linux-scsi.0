From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH resend] scsi: fc: drop residual tsk_mgmt_response and it_nexus_response
Date: Mon, 26 Jun 2017 13:02:59 -0400
Message-ID: <yq18tke7kcc.fsf@oracle.com>
References: <1498013310-29253-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498013310-29253-1-git-send-email-wangkefeng.wang@huawei.com>
        (Kefeng Wang's message of "Wed, 21 Jun 2017 10:48:30 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org


Kefeng,

> After commit 556e26a70b64 ("scsi: remove tsk_mgmt_response and
> it_nexus_response transport methods"), the target driver support was
> removed totally. Drop the residua.

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
