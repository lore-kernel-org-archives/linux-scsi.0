From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 00/21] Allow compile-testing NO_DMA (drivers)
Date: Tue, 20 Mar 2018 10:57:28 +0100
Message-ID: <CAMuHMdUUKMngcyajm_s==KbhL3ZjMNHVxhNNGkPWkpnePE2rMw@mail.gmail.com>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
 <20180316212317.7d5rri3p25hpmx44@ninjato>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180316212317.7d5rri3p25hpmx44@ninjato>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linux-iio@vger.kernel.org, linux-fpga@vger.kernel.org, linux-remoteproc@vger.kernel.org, ALSA Development Mailing List <alsa-devel@alsa-project.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Eric Anholt <eric@anholt.net>, netdev <netdev@vger.kernel.org>, MTD Maling List <linux-mtd@lists.infradead.org>, Linux I2C <linux-i2c@vger.kernel.org>, linux1394-devel@lists.sourceforge.net, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Stefan Wahren <stefan.wahren@i2se.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Herbert Xu <herbert@gondor.apana.org.au>, scsi <linux-scsi@vger.kernel.org>, Richard Weinberger <richard@nod.at>, Joerg Roedel <joro@8bytes.org>, Jassi Brar <jassisinghbrar@gmail.com>, Marek Vasut <marek.vasut@gmail.com>, linux-seria
List-Id: linux-scsi@vger.kernel.org

Hi Wolfram,

On Fri, Mar 16, 2018 at 10:23 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>> To avoid allmodconfig/allyesconfig regressions on NO_DMA=y platforms,
>> this (drivers) series should be applied after the previous (core)
>> series (but not many people may notice/care ;-)
>
> I still don't get if there is a dependency on the core patches. I.e.
> shall I apply the subsystem patch now by myself or do you want to push
> the series after the core patch and need my ack here?

Yes, there is a dependency. Without the core patches, enabling COMPILE_TEST,
and compile-testing drivers irrelevant on obscure NO_DMA=y platforms will
cause build failures.

To play it safe, you want to postpone the subsystem patches until the core
part has landed upstream. I will rebase and resubmit after v4.17-rc1.

Thanks, and sorry for being unclear.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
