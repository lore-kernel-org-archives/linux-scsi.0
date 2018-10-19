From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 6/8] rapidio: consolidate RAPIDIO config entry in drivers/rapidio
Date: Fri, 19 Oct 2018 13:53:24 +0900
Message-ID: <CAK7LNASnVLk50oYjGSE0ir3SDja3acPq1=oLjzZCLoSNiUNVdQ@mail.gmail.com>
References: <20181017080201.10866-1-hch@lst.de> <20181017080201.10866-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017080201.10866-7-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: mporter@kernel.crashing.org, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17, 2018 at 5:03 PM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no good reason to duplicate the RAPIDIO menu in various
> architectures.  Instead provide a selectable HAS_RAPIDIO symbol

Nit.

HAS_RAPIDIO -> HAVE_RAPIDIO.



> that indicates native availability of RAPIDIO support and the handle
> the rest in drivers/pci.

Copy-paste mistake?

drivers/pci -> drivers/rapidio



>  This also means we now provide support
> for PCI(e) to Rapidio bridges for every architecture instead of a
> limited subset.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>




-- 
Best Regards
Masahiro Yamada
