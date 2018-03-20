From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 06/21] fpga: Remove depends on HAS_DMA in case of
	platform dependency
Date: Tue, 20 Mar 2018 13:20:11 -0500
Message-ID: <CANk1AXRve3asPTufFYe=C_YPfyGwDpXxOWYZbWDq2bAnVkj00A@mail.gmail.com>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
	<1521208314-4783-7-git-send-email-geert@linux-m68k.org>
	<CANk1AXR3sv2=G-KsQh1p0rdcvy-3XZs6qVy5EMbcAMS6OSVzeQ@mail.gmail.com>
	<CAMuHMdU-0VOs6MYrCaCrtRfBqGgaQfox1AgbExNNcYxVC6Uh-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAMuHMdU-0VOs6MYrCaCrtRfBqGgaQfox1AgbExNNcYxVC6Uh-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Ulf Hansson <ulf.hansson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ALSA Development Mailing List <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>, Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, MTD Maling List <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Linux I2C <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux1394-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matias Bjorling <mb@lig>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 20, 2018 at 5:04 AM, Geert Uytterhoeven
<geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:

Hi Geert,

> Hi Alan,
>
> On Mon, Mar 19, 2018 at 5:06 PM, Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> On Fri, Mar 16, 2018 at 8:51 AM, Geert Uytterhoeven
>> <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:
>> This essentially removes this commit
>>
>> commit 1c8cb409491403036919dd1c6b45013dc8835a44
>> Author: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Date:   Wed Aug 3 13:45:46 2016 -0700
>>
>>     drivers/fpga/Kconfig: fix build failure
>>
>>     While building m32r allmodconfig the build is failing with the error:
>>
>>       ERROR: "bad_dma_ops" [drivers/fpga/zynq-fpga.ko] undefined!
>>
>>     Xilinx Zynq FPGA is using DMA but there was no dependency while
>>     building.
>>
>>     Link: http://lkml.kernel.org/r/1464346526-13913-1-git-send-email-sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
>>     Signed-off-by: Sudip Mukherjee <sudip.mukherjee-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
>>     Acked-by: Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>
>>     Cc: Alan Tull <atull-yzvPICuk2ABMcg4IHK0kFoH6Mc4MB0Vx@public.gmane.org>
>>     Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>     Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>
> Yes it does. The major change is that the first (core) series introduces
> all needed dummies to do successful compile-testing on NO_DMA=y platforms.

OK yes, I looked at the first patch that does the fix.  Looks good.
Thanks for doing this.

>
>>> Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
>>> symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
>>> In most cases this other symbol is an architecture or platform specific
>>> symbol, or PCI.
>>>
>>> Generic symbols and drivers without platform dependencies keep their
>>> dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
>>> cannot work anyway.
>>>
>>> This simplifies the dependencies, and allows to improve compile-testing.
>>>
>>> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
>>> Reviewed-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> Acked-by: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
Acked-by: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Regards,
Alan

>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
