From: "Bert Wesarg" <bert.wesarg@googlemail.com>
Subject: Re: [PATCH 3/6] fastboot: make the libata port scan asynchronous
Date: Wed, 7 Jan 2009 10:12:52 +0100
Message-ID: <36ca99e90901070112q6ecbb6ev5b8eafb58361674d@mail.gmail.com>
References: <20090105200959.04a626ac@infradead.org>
	 <20090105201204.2c0bf9af@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090105201204.2c0bf9af@infradead.org>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On Tue, Jan 6, 2009 at 05:12, Arjan van de Ven <arjan@infradead.org> wrote:
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index fecca42..fe2c208 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -56,6 +56,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/scatterlist.h>
>  #include <linux/io.h>
> +#include <linux/async.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_host.h>
> @@ -5909,6 +5910,48 @@ void ata_host_init(struct ata_host *host, struct device *dev,
>        host->ops = ops;
>  }
>
> +
> +void async_port_probe(void *data, async_cookie_t cookie)
static?

Bert
