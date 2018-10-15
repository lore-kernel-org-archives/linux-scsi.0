From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: move bus (PCI, PCMCIA, EISA, rapdio) config to drivers/
Date: Mon, 15 Oct 2018 15:38:18 +0900
Message-ID: <CAK7LNAQ3SNStaA6-tOWhm0QHWpNczO07x9T2F7gMcusduMS7GA@mail.gmail.com>
References: <20181013151016.31674-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013151016.31674-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: mporter@kernel.crashing.org, alex.bou9@gmail.com, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Oct 14, 2018 at 12:10 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi all,
>
> currently every architecture that wants to provide on of the common
> periphal busses needs to add some boilerplate code and include the
> right Kconfig files.   This series instead just selects the presence
> (when needed) and then handles everything in the bus-specific
> Kconfig file under drivers/.
>

Thanks for great work again.

However, I suspect some breakages
(not testing yet, just quick review by my eyes.)

I left some comments in individual patches.



--
Best Regards
Masahiro Yamada
