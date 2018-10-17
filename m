From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: move bus (PCI, PCMCIA, EISA, rapdio) config to drivers/ v2
Date: Wed, 17 Oct 2018 10:30:49 +0200
Message-ID: <CAMuHMdWMtxxu8iivcnT=uWTMHsp=iSq_QzXqDWQut5OHwTU8Sg@mail.gmail.com>
References: <20181017080201.10866-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017080201.10866-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Matt Porter <mporter@kernel.crashing.org>, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild <linux-kbuild@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Linux-Arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

On Wed, Oct 17, 2018 at 10:03 AM Christoph Hellwig <hch@lst.de> wrote:
> currently every architecture that wants to provide on of the common
> periphal busses needs to add some boilerplate code and include the
> right Kconfig files.   This series instead just selects the presence
> (when needed) and then handles everything in the bus-specific
> Kconfig file under drivers/.
>
> Changes since v1:
>  - rename all HAS_* Kconfig symbols to HAVE_*
>  - drop the CONFIG_PCI_QSPAN option entirely
>  - drop duplicate select from powerpc
>  - restore missing selection of PCI_MSI for riscv
>  - update x86 and riscv defconfigs to include PCI
>  - actually inclue drivers/eisa/Kconfig
>  - adjust some captilizations

Thanks for the update!

Please use "git format-patch -v<N> --cover" to prepare patch series
for sending with git-send-email.

  "-v<N>" to prefix all patches with version number <N>,
  "--cover" to have a "[PATCH 0/<M>]" prefix in the cover letter.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
