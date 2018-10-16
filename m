From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Tue, 16 Oct 2018 09:28:51 +0100
Message-ID: <956dafea-bca3-f3a0-318e-83399b84605c@huawei.com>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
 <yq18t354532.fsf@oracle.com>
 <e771c366-2824-8774-4c90-9906992ee813@huawei.com>
 <yq1h8hmv7kf.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1h8hmv7kf.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 16/10/2018 05:28, Martin K. Petersen wrote:
>
> John,
>
>> As I mentioned in the thread that spawned from this, we actually can't
>> expose multiple hw queues at the moment. And, if we did, we find a
>> performance drop due to having to go back to manage this IPTT
>> internally.
>>
>> So how to handle? We're going to continue to work towards exposing
>> multiple queues to upper layer, but for the moment I think patch 6/7 is
>> a good change.
>
> Thanks for the discussion. That's exactly what I was looking for.
>
> Applied to 4.20/scsi-queue.
>

Great, thanks.
