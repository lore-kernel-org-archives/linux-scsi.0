From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 4/9] powerpc: remove CONFIG_MCA leftovers
Date: Thu, 1 Nov 2018 00:31:27 +0900
Message-ID: <CAK7LNAQb3PkB_z6-3D=qotWExHGAedA5i-_ZNr83=mC6q1JtwQ@mail.gmail.com>
References: <20181019120952.32763-1-hch@lst.de> <20181019120952.32763-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019120952.32763-5-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: mporter@kernel.crashing.org, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 19, 2018 at 9:12 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> ---

Applied to linux-kbuild.



>  arch/powerpc/Kconfig | 4 ----
>  drivers/scsi/Kconfig | 6 +++---
>  2 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index e8c8970248bc..d4e97469a5f0 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -941,10 +941,6 @@ config FSL_GTM
>         help
>           Freescale General-purpose Timers support
>
> -# Yes MCA RS/6000s exist but Linux-PPC does not currently support any
> -config MCA
> -       bool
> -
>  # Platforms that what PCI turned unconditionally just do select PCI
>  # in their config node.  Platforms that want to choose at config
>  # time should select PPC_PCI_CHOICE
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
