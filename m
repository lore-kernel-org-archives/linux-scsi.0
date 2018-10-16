From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Tue, 16 Oct 2018 00:28:32 -0400
Message-ID: <yq1h8hmv7kf.fsf@oracle.com>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
        <yq18t354532.fsf@oracle.com>
        <e771c366-2824-8774-4c90-9906992ee813@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e771c366-2824-8774-4c90-9906992ee813@huawei.com> (John Garry's
        message of "Fri, 12 Oct 2018 11:47:05 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


John,

> As I mentioned in the thread that spawned from this, we actually can't
> expose multiple hw queues at the moment. And, if we did, we find a
> performance drop due to having to go back to manage this IPTT
> internally.
>
> So how to handle? We're going to continue to work towards exposing
> multiple queues to upper layer, but for the moment I think patch 6/7 is
> a good change.

Thanks for the discussion. That's exactly what I was looking for.

Applied to 4.20/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
