From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 6/7] scsi: mac_scsi: Enable PDMA on Mac IIfx
Date: Sun, 2 Jun 2019 11:04:22 +0200
Message-ID: <CAMuHMdXbJ5kuPxLKOR6v=-98vzJxoiduVkYfK0EeWze7tm5uVw@mail.gmail.com>
References: <cover.1559438652.git.fthain@telegraphics.com.au> <a69c9e248f46f02a2cdef95e2ff3d3b08531c6fa.1559438652.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a69c9e248f46f02a2cdef95e2ff3d3b08531c6fa.1559438652.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joshua Thompson <funaho@jurai.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Sun, Jun 2, 2019 at 3:29 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> Add support for Apple's custom "SCSI DMA" chip. This patch doesn't make
> use of its DMA capability. Just the PDMA capability is sufficient to
> improve sequential read throughput by a factor of 5.
>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Cc: Joshua Thompson <funaho@jurai.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Thanks for your patch!

> ---
>  arch/m68k/mac/config.c  | 10 +++++++--

For the  m68k change to go in through the SCSI tree:
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
