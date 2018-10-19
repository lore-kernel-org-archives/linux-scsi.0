From: Christoph Hellwig <hch@lst.de>
Subject: Re: move bus (PCI, PCMCIA, EISA, rapdio) config to drivers/ v2
Date: Fri, 19 Oct 2018 09:00:01 +0200
Message-ID: <20181019070001.GA30556@lst.de>
References: <20181017080201.10866-1-hch@lst.de> <CAMuHMdWMtxxu8iivcnT=uWTMHsp=iSq_QzXqDWQut5OHwTU8Sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdWMtxxu8iivcnT=uWTMHsp=iSq_QzXqDWQut5OHwTU8Sg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@lst.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Matt Porter <mporter@kernel.crashing.org>, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild <linux-kbuild@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Linux-Arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17, 2018 at 10:30:49AM +0200, Geert Uytterhoeven wrote:
> Please use "git format-patch -v<N> --cover" to prepare patch series
> for sending with git-send-email.
> 
>   "-v<N>" to prefix all patches with version number <N>,
>   "--cover" to have a "[PATCH 0/<M>]" prefix in the cover letter.

We had that discussion before and I strongly disagree with messing
up the subject lines like that.  The git-send-email defaults are
perfectly fine.
