From: Christoph Hellwig <hch@lst.de>
Subject: Re: move bus (PCI, PCMCIA, EISA, rapdio) config to drivers/ v2
Date: Fri, 19 Oct 2018 14:01:59 +0200
Message-ID: <20181019120159.GA14677@lst.de>
References: <20181017080201.10866-1-hch@lst.de> <CAMuHMdWMtxxu8iivcnT=uWTMHsp=iSq_QzXqDWQut5OHwTU8Sg@mail.gmail.com> <20181019070001.GA30556@lst.de> <CAMuHMdXLug_T4onn23JormmYZXDWVnEFYaoMzA90bpGFvk6Eow@mail.gmail.com> <20181019071057.GA31656@lst.de> <CAMuHMdXqPNOwcjWVmH08YSfZopc0pWLUj-r0s6g=q0oUdqWhWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdXqPNOwcjWVmH08YSfZopc0pWLUj-r0s6g=q0oUdqWhWw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@lst.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Matt Porter <mporter@kernel.crashing.org>, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild <linux-kbuild@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Linux-Arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 19, 2018 at 09:22:08AM +0200, Geert Uytterhoeven wrote:
> Hi Christoph,
> 
> On Fri, Oct 19, 2018 at 9:10 AM Christoph Hellwig <hch@lst.de> wrote:
> > On Fri, Oct 19, 2018 at 09:07:51AM +0200, Geert Uytterhoeven wrote:
> > > Without this:
> > >   - It's hard to visually match your untagged cover letter with the
> > > actual patches,
> > >   - Your individual patches lack the version info, so people cannot see which
> > >     version review comments in an email reply apply to.
> >
> > All of that is trivially solved by mail threading.
> 
> You forgot to answer this question:
> 
> | Can you please clarify what exactly that would mess up?

It makes the already limited space in the subject line even shorted
(or harder to read depending on which way you go) for absolutely not
good reason.
