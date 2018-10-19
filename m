From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 7/8] eisa: consolidate EISA Kconfig entry in drivers/eisa
Date: Fri, 19 Oct 2018 13:48:19 +0900
Message-ID: <CAK7LNATAk1oL8xbwp4RqMcZc5CtU7=YCqN2wHcSOq4RsJtJgRA@mail.gmail.com>
References: <20181017080201.10866-1-hch@lst.de> <20181017080201.10866-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017080201.10866-8-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: mporter@kernel.crashing.org, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17, 2018 at 5:03 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Let architectures opt into EISA support by selecting HAS_EISA and

Nit.

HAS_EISA -> HAVE_EISA
since you renamed it in this version.



> handle everything else in drivers/eisa.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> ---
-- 
Best Regards
Masahiro Yamada
