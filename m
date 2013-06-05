From: Libo Chen <libo.chen@huawei.com>
Subject: Re: [PATCH v2] scsi: megaraid: check kzalloc
Date: Wed, 5 Jun 2013 09:27:34 +0800
Message-ID: <51AE9406.7080102@huawei.com>
References: <519ECEF1.9060804@huawei.com> <519F3592.4090207@huawei.com> <51ADB484.3060404@huawei.com> <51ADDA24.7050609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51ADDA24.7050609@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: megaraidlinux@lsi.com, JBottomley@parallels.com, Libo Chen <chenlibo.3@gmail.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kashyap.desai@lsi.com, aradford@gmail.com, Li Zefan <lizefan@huawei.com>, Santosh Y <santoshsy@gmail.com>, "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 2013/6/4 20:14, Tomas Henzl wrote:
> On 06/04/2013 11:33 AM, Libo Chen wrote:
>> we should check kzalloc, avoid to hit oops
>>
>> Change from v1:
>> - put kzalloc outside of mutex
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> 
> Your patch looks fine to me:
> Acked-by: Tomas Henzl <thenzl@redhat.com>
> 

your ack is very helpfull for me.

Thanks,

Libo

> Cheers,
> Tomas
> 
> 
> .
> 
