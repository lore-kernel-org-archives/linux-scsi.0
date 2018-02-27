From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH] scsi: core: use blk_mq_requeue_request in
 __scsi_queue_insert
Date: Tue, 27 Feb 2018 13:15:10 +0800
Message-ID: <478f40f1-d86c-ee5f-daaf-6332b67fe721@oracle.com>
References: <1519631932-1730-1-git-send-email-jianchao.w.wang@oracle.com>
 <1519700898.3120.3.camel@wdc.com>
 <3b6ca136-ba62-3eca-6eca-d191490b7754@oracle.com>
 <1519702875.3120.7.camel@wdc.com>
 <db9c47e6-d8ea-1e9e-609a-ff1b1db3769c@oracle.com>
 <1519708355.3120.9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519708355.3120.9.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi Bart

Thanks for your kindly response.

On 02/27/2018 01:12 PM, Bart Van Assche wrote:
> On Tue, 2018-02-27 at 12:00 +0800, jianchao.wang wrote:
>> On the other hand, this patch is to align the actions between blk-mq and block
>> legacy code in __scsi_queue_insert.
> 
> Hello Jianchao,
> 
> Since the legacy SCSI core unpreps an reprepares a request when requeuing it I
> think your patch does not align the blk-mq and legacy block layer actions but
> instead makes the behavior of the two code paths different.
> 

Can you share more details about this ? 

Thanks 
Jianchao 
