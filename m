From: Weidong Wang <wangweidong1@huawei.com>
Subject: Re: [PATCH 1/3] megaraid_sas: Convert dev_printk to dev_<level>
Date: Wed, 28 Oct 2015 10:31:00 +0800
Message-ID: <56303364.3030701@huawei.com>
References: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>  <1445934375-17784-2-git-send-email-wangweidong1@huawei.com> <1445941550.16404.37.camel@suse.de> <6aed31d964ce36a682947820eee7cbc1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6aed31d964ce36a682947820eee7cbc1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, JBottomley@odin.com, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2015/10/27 18:33, Kashyap Desai wrote:
>>> +		dev_dbg(&instance->pdev->dev, "Error copying out
>>> cmd_status\n");
>>>  		error = -EFAULT;
>>>  	}
>>>
>>
>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> 
> We will consider all three patches for future submission. As of now we have
> two patch set pending to be committed.
> We are working for few more patch in megaraid_sas which will do clean up in
> driver module + proper error handling of DCMD command timeout. It will cover
> Patch posted with below subject -
> 
> [PATCH 3/3] megaraid_sas: return -ENOMEM when create DMA pool for cmd frames
> failed
> 

Ok. And that, can you add Signed-off-by with me as well?

Regards,
Weidong

> James  -  We will be resending these patch set on top of latest outstanding
> megaraid_sas driver patch, so that we can avoid any conflict in commits.
>
> 
