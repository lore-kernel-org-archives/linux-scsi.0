From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH -next] scsi: initio: Make some functions static
Date: Fri, 26 Jul 2019 19:28:49 +0200
Message-ID: <CAK8P3a0q4BVxjEHOAmO2hQGKBWObYitC=ix-Jy8fPuxPxbk0ag@mail.gmail.com>
References: <20190726135814.48760-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190726135814.48760-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 26, 2019 at 3:59 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fix sparse warnings:
>
> drivers/scsi/initio.c:881:22: warning: symbol 'initio_find_busy_scb' was not declared. Should it be static?
> drivers/scsi/initio.c:919:22: warning: symbol 'initio_find_done_scb' was not declared. Should it be static?
> drivers/scsi/initio.c:1657:5: warning: symbol 'initio_state_7' was not declared. Should it be static?
> drivers/scsi/initio.c:1743:5: warning: symbol 'initio_xpad_in' was not declared. Should it be static?
> drivers/scsi/initio.c:1767:5: warning: symbol 'initio_xpad_out' was not declared. Should it be static?
> drivers/scsi/initio.c:1792:5: warning: symbol 'initio_status_msg' was not declared. Should it be static?
> drivers/scsi/initio.c:1842:5: warning: symbol 'int_initio_busfree' was not declared. Should it be static?
> drivers/scsi/initio.c:1912:5: warning: symbol 'int_initio_resel' was not declared. Should it be static?
> drivers/scsi/initio.c:2368:5: warning: symbol 'initio_bus_device_reset' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

The patch looks fine, but I wonder if sparse should print a different
warning message
here. Note that those functions are in fact static, they just have a
'static' forward
declaration followed by a definition without the 'static' keyword.

The change does improve readability of course, so maybe it's not worth changing
sparse.

      Arnd
