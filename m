From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] scsi:NCR5380: remove same check condition in NCR5380_select
Date: Fri, 3 Aug 2018 12:10:31 +0300
Message-ID: <CAHp75Vc8tWKUpKS8yY52CdJ=mU-iqcrUCz32ZSSJixLA1bM0tQ@mail.gmail.com>
References: <1533179408-20631-1-git-send-email-zhongjiang@huawei.com> <alpine.LNX.2.21.1808031156350.16@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1808031156350.16@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Julia Lawall <julia.lawall@lip6.fr>
Cc: zhong jiang <zhongjiang@huawei.com>, Michael Schmitz <schmitzmic@gmail.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry@huawei.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 3, 2018 at 5:24 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Thu, 2 Aug 2018, zhong jiang wrote:
>
>> The same check condition is redundant, so remove one of them.
>>
>
> If you are trying to find redundant code, your coccinelle script is
> dangerously flawed.

These days too many coccinelle helpers make people think they are
doing right "clean ups" when in the practice they bring the
regressions.

Julia, is possible by coccinelle to distinguish memory accesses versus
I/O? At least it would increase robustness in some cases.

-- 
With Best Regards,
Andy Shevchenko
