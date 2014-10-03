From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 17/29] dmx3191d: Use IRQ_NONE
Date: Fri, 3 Oct 2014 10:41:47 +0200
Message-ID: <CAMuHMdVXJJxYR_EFkUvH9feN=__PZM=j6+r0SWQrd_vFsSDAsQ@mail.gmail.com>
References: <20141002065628.256592712@telegraphics.com.au>
	<20141002065632.335868715@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141002065632.335868715@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 2, 2014 at 8:56 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> Testing shows that the Domex 3191D card never asserts its IRQ. Hence it is
> non-functional with Linux (worse, the EH bugs in the core driver are fatal but
> that's a problem for another patch). Perhaps the DT-536 chip needs special
> setup? I can't find documentation for it. The NetBSD driver uses polling
> apparently because of this issue.
>
> Set host->irq = IRQ_NONE so the core driver will prevent targets from
> disconnecting. Don't request the irq.

Please use plain 0 instead of IRQ_NONE (which is related to irqreturn_t).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
