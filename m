From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/8] powerpc: simplify CONFIG_PCI_QSPAN Kconfig magic
Date: Mon, 15 Oct 2018 10:47:21 +0200
Message-ID: <20181015084721.GB27159@lst.de>
References: <20181013151016.31674-1-hch@lst.de> <20181013151016.31674-3-hch@lst.de> <CAK7LNAQxZcBNadLJhfrmxJGj-XJFVaya3Z1eexZp20vRPwrN7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK7LNAQxZcBNadLJhfrmxJGj-XJFVaya3Z1eexZp20vRPwrN7A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Christoph Hellwig <hch@lst.de>, mporter@kernel.crashing.org, alex.bou9@gmail.com, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 15, 2018 at 03:35:41PM +0900, Masahiro Yamada wrote:
> 'git grep' did not get any other hit.
> 
> masahiro@pug:~/ref/linux$ git grep PCI_QSPAN
> arch/powerpc/Kconfig:   default PCI_QSPAN if PPC_8xx
> arch/powerpc/Kconfig:config PCI_QSPAN
> 
> With your patch, PCI_QSPAN will become
> a dead config option.
> 
> How about removing it entirely?

Yes, it should just go away.  Thanks!
