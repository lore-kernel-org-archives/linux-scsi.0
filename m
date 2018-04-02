From: Jason Yan <yanaijie@huawei.com>
Subject: =?UTF-8?Q?Re:_=e7=ad=94=e5=a4=8d:_Re:_[PATCH_v2]_scsi:_Introduce_sd?=
 =?UTF-8?Q?ev=5fprintk=5fratelimited_to_throttlefrequent_printk?=
Date: Mon, 2 Apr 2018 14:07:59 +0800
Message-ID: <5AC1C8BF.1030503@huawei.com>
References: <5AC1976F.1040801@huawei.com> <201804021314481872986@zte.com.cn>
 <20180402052920.GF3795@jagdpanzerIV>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180402052920.GF3795@jagdpanzerIV>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, wen.yang99@zte.com.cn
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart.VanAssche@wdc.com, pmladek@suse.com, tj@kernel.org, jiang.biao2@zte.com.cn, zhong.weidong@zte.com.cn, tan.hu@zte.com.cn
List-Id: linux-scsi@vger.kernel.org



On 2018/4/2 13:29, Sergey Senozhatsky wrote:
> On (04/02/18 13:14), wen.yang99@zte.com.cn wrote:
>>
>>     > It's true that this print for the same device is useless. But it's
>>     > useful for different devices. Is it possible to limit the print only
>>     > for the same device?
>>
>>     In our scene, it's  just for the same device (q->queuedata), Thanks.
>
> Yes, what Jason meant was that rate limit struct is shared by different call
> sites - including scsi_request_fn() from different devices.
>
> If device1->scsi_request_fn()->sdev_printk_ratelimited() causes printk rate
> limit, then messages from device2->scsi_request_fn()->sdev_printk_ratelimited()
> may be lost entirely, unless you have enough of them.
>
> 	-ss
>

Yes, that's exactly what I mean.

Thanks,

Jason

> .
>
