From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 8/8] kconfig: remove CONFIG_MCA leftovers
Date: Tue, 16 Oct 2018 14:20:23 +0900
Message-ID: <CAK7LNAQwyWUq_ohVMe9QLLbyHHQdjkrkM9DPd3pgYLz8UhG6rA@mail.gmail.com>
References: <20181013151016.31674-1-hch@lst.de> <20181013151016.31674-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013151016.31674-9-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: mporter@kernel.crashing.org, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Oct 14, 2018 at 12:11 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Can you use "powerpc:" or something
for the subject line?

I'd like to see "kconfig:" only for patches
that touch the scripts/kconfig/ directory.




>  arch/powerpc/Kconfig | 4 ----
>  drivers/scsi/Kconfig | 6 +++---
>  2 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index f0ea460653cd..8b9edf7caf96 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -944,10 +944,6 @@ config FSL_GTM
>         help
>           Freescale General-purpose Timers support
>
> -# Yes MCA RS/6000s exist but Linux-PPC does not currently support any
> -config MCA
> -       bool
> -
>  config PCI_DOMAINS
>         def_bool PCI
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 7c097006c54d..d3734c54aec9 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -535,7 +535,7 @@ config SCSI_HPTIOP
>
>  config SCSI_BUSLOGIC
>         tristate "BusLogic SCSI support"
> -       depends on (PCI || ISA || MCA) && SCSI && ISA_DMA_API && VIRT_TO_BUS
> +       depends on (PCI || ISA) && SCSI && ISA_DMA_API && VIRT_TO_BUS
>         ---help---
>           This is support for BusLogic MultiMaster and FlashPoint SCSI Host
>           Adapters. Consult the SCSI-HOWTO, available from
> @@ -1142,12 +1142,12 @@ config SCSI_LPFC_DEBUG_FS
>
>  config SCSI_SIM710
>         tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
> -       depends on (EISA || MCA) && SCSI
> +       depends on EISA && SCSI
>         select SCSI_SPI_ATTRS
>         ---help---
>           This driver is for NCR53c710 based SCSI host adapters.
>
> -         It currently supports Compaq EISA cards and NCR MCA cards
> +         It currently supports Compaq EISA cards.
>
>  config SCSI_DC395x
>         tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support"
> --
> 2.19.1
>


-- 
Best Regards
Masahiro Yamada
