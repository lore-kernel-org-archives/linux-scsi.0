From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 8/8] kconfig: remove CONFIG_MCA leftovers
Date: Wed, 17 Oct 2018 10:17:06 +0200
Message-ID: <20181017081706.GA24869@lst.de>
References: <20181013151016.31674-1-hch@lst.de> <20181013151016.31674-9-hch@lst.de> <CAK7LNAQwyWUq_ohVMe9QLLbyHHQdjkrkM9DPd3pgYLz8UhG6rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK7LNAQwyWUq_ohVMe9QLLbyHHQdjkrkM9DPd3pgYLz8UhG6rA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Christoph Hellwig <hch@lst.de>, mporter@kernel.crashing.org, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 16, 2018 at 02:20:23PM +0900, Masahiro Yamada wrote:
> On Sun, Oct 14, 2018 at 12:11 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> 
> Can you use "powerpc:" or something
> for the subject line?
> 
> I'd like to see "kconfig:" only for patches
> that touch the scripts/kconfig/ directory.

Sorry, I missed this for v2.  Will fix it up for the next version
or let you fix it up if there isn't one.
