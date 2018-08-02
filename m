From: zhong jiang <zhongjiang@huawei.com>
Subject: Re: [PATCH 1/4] driver/scsi/fnic/fnic_trace: Use vzalloc to zero
 instead of vmalloc+memset
Date: Thu, 2 Aug 2018 14:16:47 +0800
Message-ID: <5B62A1CF.7040904@huawei.com>
References: <1533129976-51930-1-git-send-email-zhongjiang@huawei.com> <1533129976-51930-2-git-send-email-zhongjiang@huawei.com> <CAHp75Vchu7QwNBeYQxa9fY8=PinGzPpUPaRbk_MyoZ+w07hA4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75Vchu7QwNBeYQxa9fY8=PinGzPpUPaRbk_MyoZ+w07hA4A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: John Garry <john.garry@huawei.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, aacraid@microsemi.com, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018/8/1 23:30, Andy Shevchenko wrote:
> On Wed, Aug 1, 2018 at 4:26 PM, zhong jiang <zhongjiang@huawei.com> wrote:
>> The vzalloc is better than vmalloc+memset, so replace them to make
>> the code concise.
>> -       fnic_trace_buf_p = (unsigned long)vmalloc((trace_max_pages * PAGE_SIZE));
>> +       fnic_trace_buf_p = (unsigned long)vzalloc((trace_max_pages * PAGE_SIZE));
> At the same time you may get rid of unnecessary parens.
>
Thanks , I will repost with the change.

Thanks
zhong jiang
