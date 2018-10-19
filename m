From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/8] PCI: consolidate PCI config entry in drivers/pci
Date: Fri, 19 Oct 2018 09:02:24 +0200
Message-ID: <20181019070224.GB30556@lst.de>
References: <20181017080201.10866-1-hch@lst.de> <20181017080201.10866-5-hch@lst.de> <CAK7LNASJaRrut2neRa92CudohW4A-2=GHMzgEpOzT97VdGuhng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK7LNASJaRrut2neRa92CudohW4A-2=GHMzgEpOzT97VdGuhng@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-pci@vger.kernel.org, mporter@kernel.crashing.org, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 19, 2018 at 02:07:04PM +0900, Masahiro Yamada wrote:
> We could add 'depends on HAVE_PCI' or something
> to guard it to avoid changing the logic.

I guess that makes sense.

> config PCI_ENDPOINT
>         bool "PCI Endpoint Support"
>         depends on HAVE_PCI     # Is this correct ??
>         depends on HAS_DMA
> 
> 
> or better to have 'depends on PCI' ?

It does not depend on the normal PCI support, so I don't think this
is the right thing to do.
