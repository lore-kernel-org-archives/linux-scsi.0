From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH V2] scsi: core: use blk_mq_requeue_request in
 __scsi_queue_insert
Date: Fri, 2 Mar 2018 10:18:12 +0800
Message-ID: <f7e93d3c-f7ee-0142-73b7-60ff868fcb34@oracle.com>
References: <1519808113-2863-1-git-send-email-jianchao.w.wang@oracle.com>
 <yq1371jz1xx.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1371jz1xx.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, Bart.VanAssche@wdc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi martin

On 03/02/2018 09:44 AM, Martin K. Petersen wrote:
>> In scsi core, __scsi_queue_insert should just put request back on the
>> queue and retry using the same command as before. However, for blk-mq,
>> scsi_mq_requeue_cmd is employed here which will unprepare the
>> request. To align with the semantics of __scsi_queue_insert, use
>> blk_mq_requeue_request with kick_requeue_list == true and put the
>> reference of scsi_device.
>>
>> V1 -> V2:
>>  - add put_device on scsi_device->sdev_gendev
> Also, please put changelog after the --- delimiter.
> 

Yes, I will modify this next version.

Thanks 
Jianchao
