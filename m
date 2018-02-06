From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH/RFC 0/6] Allow compile-testing NO_DMA
Date: Tue, 6 Feb 2018 16:24:49 +0100
Message-ID: <CAK8P3a1K+N54DeTcq4CL76GTD0Nb3WwozN3YoNdnrQW_2oC6jA@mail.gmail.com>
References: <1517912092-15470-1-git-send-email-geert@linux-m68k.org> <c68d8b8b-dc46-2066-0341-558f57ad113f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c68d8b8b-dc46-2066-0341-558f57ad113f@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Mark Brown <broonie@kernel.org>, Richard Weinberger <richard@nod.at>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>, linux-usb@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 6, 2018 at 2:05 PM, Robin Murphy <robin.murphy@arm.com> wrote:
>
> It looks like we have only one real arch (score) without IOMEM, and two
> (s390 and tile) where it is possible to configure out, so it does seem like
> a reasonable feature to assume. Maybe we could have something like
> asm-generic/no-io.h to provide an "unimplemented" version of those
> interfaces.

Agreed, there is no use trying to optimize for any of those three cases:

For s390, all new machines come with PCI, so distros will enable it all
the time. Few users run their own kernels even on older machines.

score has been de-facto unmaintained for a few years, and tile has
recently been orphaned with the hardware platform being abandoned by
Mellanox.

      Arnd
