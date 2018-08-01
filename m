From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 2/4] drivers/scsi/dpt_i2o: Use dma_zalloc_coherent to
 repalce dma_alloc_coherent+memset
Date: Wed, 1 Aug 2018 18:32:45 +0300
Message-ID: <CAHp75VenNAyShMv_GhMZrwnOKpDHTxRTsx_h_sQcLR-RkJj5Zg@mail.gmail.com>
References: <1533129976-51930-1-git-send-email-zhongjiang@huawei.com> <1533129976-51930-3-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533129976-51930-3-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Cc: John Garry <john.garry@huawei.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, aacraid@microsemi.com, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 1, 2018 at 4:26 PM, zhong jiang <zhongjiang@huawei.com> wrote:
> we prefer to dma_zalloc_coherent rather than open code dma_alloc_coherent+memset
> , so just replace them.

Capitalize your sentences along with proper use of function()
references and comma(s).

... dma_alloc_coherent() + memset(), ...

-- 
With Best Regards,
Andy Shevchenko
