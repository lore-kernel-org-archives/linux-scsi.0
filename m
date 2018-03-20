From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH v2 10/21] lightnvm: Remove depends on HAS_DMA in case of
	platform dependency
Date: Tue, 20 Mar 2018 11:09:06 +0100
Message-ID: <CAMuHMdXZNqO0NDESs9Y3uJs0kmQSXY05ei0xJE9uT9EUixuxAQ@mail.gmail.com>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
	<1521208314-4783-11-git-send-email-geert@linux-m68k.org>
	<AM5PR04MB3267989AB6A81639F61AB165ECD40@AM5PR04MB3267.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <AM5PR04MB3267989AB6A81639F61AB165ECD40-cEGzClBroOnsqXY5KrYE589NdZoXdze2vxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Madalin-cristian Bucur <madalin.bucur-3arQi8VN3Tc@public.gmane.org>
Cc: Ulf Hansson <ulf.hansson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org" <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>, Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux1394-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <linux1394-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-s
List-Id: linux-scsi@vger.kernel.org

Hi Madalin-cristian,

On Mon, Mar 19, 2018 at 6:27 AM, Madalin-cristian Bucur
<madalin.bucur-3arQi8VN3Tc@public.gmane.org> wrote:
>> -----Original Message-----
>> From: netdev-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:netdev-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
>> On Behalf Of Geert Uytterhoeven
>> Remove dependencies on HAS_DMA where a Kconfig symbol depends on
>> another
>> symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
>> In most cases this other symbol is an architecture or platform specific
>> symbol, or PCI.
>>
>> Generic symbols and drivers without platform dependencies keep their
>> dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
>> cannot work anyway.
>>
>> This simplifies the dependencies, and allows to improve compile-testing.
>>
>> Notes:
>>   - FSL_FMAN keeps its dependency on HAS_DMA, as it calls set_dma_ops(),
>>     which does not exist if HAS_DMA=n (Do we need a dummy? The use of
>>     set_dma_ops() in this driver is questionable),
>
> Hi,
>
> The set_dma_ops() is no longer required in the fsl/fman, I'll send a patch to remove it.

Thank you, looking forward to it!

>>   - SND_SOC_LPASS_IPQ806X and SND_SOC_LPASS_PLATFORM loose their
>>     dependency on HAS_DMA, as they are selected from
>>     SND_SOC_APQ8016_SBC.
>>
>> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
>> Reviewed-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Acked-by: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
