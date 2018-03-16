From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 00/21] Allow compile-testing NO_DMA (drivers)
Date: Fri, 16 Mar 2018 16:41:57 +0100
Message-ID: <CAMuHMdUKULvoB6-6EhsYpdbWEEEfjtn27GbzpXj7+Mz+=qeOnw@mail.gmail.com>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
 <20180316151410.GA6527@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180316151410.GA6527@gondor.apana.org.au>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Wolfram Sang <wsa@the-dreams.de>, linux-iio@vger.kernel.org, linux-fpga@vger.kernel.org, linux-remoteproc@vger.kernel.org, ALSA Development Mailing List <alsa-devel@alsa-project.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Eric Anholt <eric@anholt.net>, netdev <netdev@vger.kernel.org>, MTD Maling List <linux-mtd@lists.infradead.org>, Linux I2C <linux-i2c@vger.kernel.org>, linux1394-devel@lists.sourceforge.net, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Stefan Wahren <stefan.wahren@i2se.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, scsi <linux-scsi@vger.kernel.org>, Richard Weinberger <richard@nod.at>, Joerg Roedel <joro@8bytes.org>, Jassi Brar <jassisinghbrar@gmail.com>, Marek Vasut <marek.vasut@gmail.com>, linux-serial@vger.k
List-Id: linux-scsi@vger.kernel.org

Hi Herbert,

On Fri, Mar 16, 2018 at 4:14 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Mar 16, 2018 at 02:51:33PM +0100, Geert Uytterhoeven wrote:
>> This patch series:
>>   - Removes dependencies on HAS_DMA for symbols that already have
>>     platform dependencies implying HAS_DMA.
>>
>> To avoid allmodconfig/allyesconfig regressions on NO_DMA=y platforms,
>> this (drivers) series should be applied after the previous (core)
>> series (but not many people may notice/care ;-)
>>
>> Changes compared to v1:
>>   - Add Reviewed-by, Acked-by,
>>   - Drop dependency of SND_SOC_LPASS_IPQ806X on HAS_DMA,
>>   - Drop dependency of VIDEOBUF{,2}_DMA_{CONTIG,SG} on HAS_DMA,
>>   - Drop new dependencies of VIDEO_IPU3_CIO2, DVB_C8SECTPFE, and
>>     MTD_NAND_MARVELL on HAS_DMA,
>>   - Split in per-subsystem patches,
>>   - Split-off the core part in a separate series.
>>
>> This series is against v4.16-rc5. It can also be found at
>> https://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git/log/?h=no-dma-compile-testing-v2
>>
>> It has been compile-tested with allmodconfig and allyesconfig for
>> m68k/sun3, and has received attention from the kbuild test robot.
>
> Do these patches have any dependencies? Can they be applied directly
> in a subsystem tree?

| To avoid allmodconfig/allyesconfig regressions on NO_DMA=y platforms,
| this (drivers) series should be applied after the previous (core)
| series (but not many people may notice/care ;-)

Apart from introducing build failures in allmodconfig/allyesconfig builds on
(uncommon) NO_DMA=y platforms, they can be applied directly and individually.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
