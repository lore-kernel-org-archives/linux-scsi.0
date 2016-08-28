From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/3] scsi/ncr5380: Avoid a compiler warning
Date: Sun, 28 Aug 2016 10:08:08 +0200
Message-ID: <CAMuHMdVQBeHoH12bvyni0XnyahyrrKTtkZv4ogR0nTaRow5GNg@mail.gmail.com>
References: <20160827022958.983743612@telegraphics.com.au> <20160827022959.211730285@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160827022959.211730285@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 27, 2016 at 4:30 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> With commit 3a0f64bfa907 ("mac_scsi: Fix pseudo DMA implementation")
> some versions of gcc now warn:
>
> In file included from drivers/scsi/mac_scsi.c:335:
> drivers/scsi/NCR5380.h:295: warning: `NCR5380_poll_politely' declared inline after being called
> drivers/scsi/NCR5380.h:295: warning: previous declaration of `NCR5380_poll_politely' was here
>
> Avoid this by defining NCR5380_poll_politely() in NCR5380.h.
>
> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
