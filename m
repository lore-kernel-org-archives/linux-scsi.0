From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: move bus (PCI, PCMCIA, EISA, rapdio) config to drivers/ v2
Date: Fri, 19 Oct 2018 09:07:51 +0200
Message-ID: <CAMuHMdXLug_T4onn23JormmYZXDWVnEFYaoMzA90bpGFvk6Eow@mail.gmail.com>
References: <20181017080201.10866-1-hch@lst.de> <CAMuHMdWMtxxu8iivcnT=uWTMHsp=iSq_QzXqDWQut5OHwTU8Sg@mail.gmail.com>
 <20181019070001.GA30556@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019070001.GA30556@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Matt Porter <mporter@kernel.crashing.org>, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild <linux-kbuild@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Linux-Arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

On Fri, Oct 19, 2018 at 9:00 AM Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Oct 17, 2018 at 10:30:49AM +0200, Geert Uytterhoeven wrote:
> > Please use "git format-patch -v<N> --cover" to prepare patch series
> > for sending with git-send-email.
> >
> >   "-v<N>" to prefix all patches with version number <N>,
> >   "--cover" to have a "[PATCH 0/<M>]" prefix in the cover letter.
>
> We had that discussion before and I strongly disagree with messing
> up the subject lines like that.  The git-send-email defaults are
> perfectly fine.

Can you please clarify what exactly that would mess up?
Documentation/process/submitting-patches.rst even mentions the tags
to put in "[PATCH <tag>]"?

Without this:
  - It's hard to visually match your untagged cover letter with the
actual patches,
  - Your individual patches lack the version info, so people cannot see which
    version review comments in an email reply apply to.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
