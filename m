From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/8] powerpc: remove CONFIG_PCI_QSPAN
Date: Wed, 17 Oct 2018 20:10:42 +1100
Message-ID: <33a2232671caa008541f8de542f8e7a27ab88248.camel@kernel.crashing.org>
References: <20181017080201.10866-1-hch@lst.de>
         <20181017080201.10866-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017080201.10866-3-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-arch@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Dominik Brodowski <linux@dominikbrodowski.net>, Alexandre Bounine <alex.bou9@gmail.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-10-17 at 10:01 +0200, Christoph Hellwig wrote:
> This option isn't actually used anywhere.

Oh my, that's ancient. Probably didn't make the cut from arch/ppc to
arch/powerpc

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  arch/powerpc/Kconfig | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index a80669209155..e8c8970248bc 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -955,7 +955,6 @@ config PCI
>  	bool "PCI support" if PPC_PCI_CHOICE
>  	default y if !40x && !CPM2 && !PPC_8xx && !PPC_83xx \
>  		&& !PPC_85xx && !PPC_86xx && !GAMECUBE_COMMON
> -	default PCI_QSPAN if PPC_8xx
>  	select GENERIC_PCI_IOMAP
>  	help
>  	  Find out whether your system includes a PCI bus. PCI is the name of
> @@ -969,14 +968,6 @@ config PCI_DOMAINS
>  config PCI_SYSCALL
>  	def_bool PCI
>  
> -config PCI_QSPAN
> -	bool "QSpan PCI"
> -	depends on PPC_8xx
> -	select PPC_I8259
> -	help
> -	  Say Y here if you have a system based on a Motorola 8xx-series
> -	  embedded processor with a QSPAN PCI interface, otherwise say N.
> -
>  config PCI_8260
>  	bool
>  	depends on PCI && 8260
