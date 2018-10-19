From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 7/8] eisa: consolidate EISA Kconfig entry in drivers/eisa
Date: Fri, 19 Oct 2018 13:46:50 +0900
Message-ID: <CAK7LNAT0pzpMZC+X5KiofPCUH89hr716WCKQkNYronQa3byT9w@mail.gmail.com>
References: <20181017080201.10866-1-hch@lst.de> <20181017080201.10866-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017080201.10866-8-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: mporter@kernel.crashing.org, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17, 2018 at 5:03 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Let architectures opt into EISA support by selecting HAS_EISA and
> handle everything else in drivers/eisa.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> ---


> index 60e37b9a715d..c90a1a4d6079 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -59,6 +59,7 @@ config ARM
>         select HAVE_ARCH_TRACEHOOK
>         select HAVE_ARM_SMCCC if CPU_V7
>         select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
> +       select HAVE_EISA

I doubt this.

arch/arm/Kconfig previously did not include
driver/eisa/Kconfig.

No ARM platform enabled CONFIG_EISA either.


>         select HAVE_CONTEXT_TRACKING
>         select HAVE_C_RECORDMCOUNT
>         select HAVE_DEBUG_KMEMLEAK
> @@ -162,21 +163,6 @@ config HAVE_PROC_CPU
>  config NO_IOPORT_MAP
>         bool
>
> -config EISA
> -       bool
> -       ---help---
> -         The Extended Industry Standard Architecture (EISA) bus was
> -         developed as an open alternative to the IBM MicroChannel bus.
> -
> -         The EISA bus provided some of the features of the IBM MicroChannel
> -         bus while maintaining backward compatibility with cards made for
> -         the older ISA bus.  The EISA bus saw limited use between 1988 and
> -         1995 when it was made obsolete by the PCI bus.
> -
> -         Say Y here if you are building a kernel for an EISA-based machine.
> -
> -         Otherwise, say N.
> -
>  config SBUS
>         bool
>


-- 
Best Regards
Masahiro Yamada
