From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Thu, 11 Oct 2018 10:59:11 +0100
Message-ID: <118d01db-05f4-a85b-850c-c4e5a5616a16@huawei.com>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
 <yq18t354532.fsf@oracle.com> <20181011063603.GA3456@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181011063603.GA3456@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 11/10/2018 07:36, Christoph Hellwig wrote:
> On Wed, Oct 10, 2018 at 09:58:25PM -0400, Martin K. Petersen wrote:
>>> This is because the IPTT index must be a unique value per HBA. However,
>>> if we switched to SCSI MQ, the block layer tag becomes unique per queue,
>>> and not per HBA.
>>
>> That doesn't sound right.
>

Hmmm, well this is what I was told ...

> blk-mq tags are always per-host (which has actually caused problems for
> ATA, which is now using its own per-device tags).
>

So, for example, if Scsi_host.can_queue = 2048 and 
Scsi_host.nr_hw_queues = 16, then rq tags are still in range [0, 2048) 
for that HBA, i.e. invariant on queue count?

> .
>

Thanks,
John
