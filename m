From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/8] eisa: consolidate EISA Kconfig entry in
 drivers/eisa
Date: Fri, 19 Oct 2018 09:06:54 +0200
Message-ID: <20181019070654.GC30556@lst.de>
References: <20181017080201.10866-1-hch@lst.de> <20181017080201.10866-8-hch@lst.de> <CAK7LNAT0pzpMZC+X5KiofPCUH89hr716WCKQkNYronQa3byT9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK7LNAT0pzpMZC+X5KiofPCUH89hr716WCKQkNYronQa3byT9w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Christoph Hellwig <hch@lst.de>, mporter@kernel.crashing.org, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 19, 2018 at 01:46:50PM +0900, Masahiro Yamada wrote:
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -59,6 +59,7 @@ config ARM
> >         select HAVE_ARCH_TRACEHOOK
> >         select HAVE_ARM_SMCCC if CPU_V7
> >         select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
> > +       select HAVE_EISA
> 
> I doubt this.
> 
> arch/arm/Kconfig previously did not include
> driver/eisa/Kconfig.
> 
> No ARM platform enabled CONFIG_EISA either.

But it did offer the EISA option.  I guess I can remove this in
a separate commit and see if anyone screams.
