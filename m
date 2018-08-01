From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 1/4] driver/scsi/fnic/fnic_trace: Use vzalloc to zero
 instead of vmalloc+memset
Date: Wed, 1 Aug 2018 18:30:58 +0300
Message-ID: <CAHp75Vchu7QwNBeYQxa9fY8=PinGzPpUPaRbk_MyoZ+w07hA4A@mail.gmail.com>
References: <1533129976-51930-1-git-send-email-zhongjiang@huawei.com> <1533129976-51930-2-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533129976-51930-2-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Cc: John Garry <john.garry@huawei.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, aacraid@microsemi.com, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 1, 2018 at 4:26 PM, zhong jiang <zhongjiang@huawei.com> wrote:
> The vzalloc is better than vmalloc+memset, so replace them to make
> the code concise.

> -       fnic_trace_buf_p = (unsigned long)vmalloc((trace_max_pages * PAGE_SIZE));
> +       fnic_trace_buf_p = (unsigned long)vzalloc((trace_max_pages * PAGE_SIZE));

At the same time you may get rid of unnecessary parens.

-- 
With Best Regards,
Andy Shevchenko
