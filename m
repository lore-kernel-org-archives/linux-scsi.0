From: Jason Yan <yanaijie@huawei.com>
Subject: =?UTF-8?Q?Re:_=e7=ad=94=e5=a4=8d:_Re:_[PATCH_v2]_scsi:_Introduce_sd?=
 =?UTF-8?Q?ev=5fprintk=5fratelimited_to_throttlefrequent_printk?=
Date: Mon, 2 Apr 2018 14:06:19 +0800
Message-ID: <5AC1C85B.4010804@huawei.com>
References: 1522634332-151328-1-git-send-email-wen.yang99@zte.com.cn
 5AC1976F.1040801@huawei.com <201804021314481872986@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201804021314481872986@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: wen.yang99@zte.com.cn
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart.VanAssche@wdc.com, pmladek@suse.com, sergey.senozhatsky.work@gmail.com, tj@kernel.org, jiang.biao2@zte.com.cn, zhong.weidong@zte.com.cn, tan.hu@zte.com.cn
List-Id: linux-scsi@vger.kernel.org



On 2018/4/2 13:14, wen.yang99@zte.com.cn wrote:
> Hello,
>
>  > It's true that this print for the same device is useless. But it's
>
>  > useful for different devices. Is it possible to limit the print only
>
>  > for the same device?
>
>
> In our scene, it's  just for the same device (q->queuedata), Thanks.
>

I mean the print limit you add will affect all devices. One device's 
print *may* cause another device's print limited even if it only printed 
one message.
