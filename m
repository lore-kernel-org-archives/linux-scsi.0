From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH #upstream-fixes] libata: Add transport class for libata
Date: Tue, 19 Aug 2008 06:27:38 -0600
Message-ID: <20080819122738.GC21854@parisc-linux.org>
References: <e7510f760808182131q1bd3aa4bp694ebff75b612995@mail.gmail.com> <48AAAFAC.9050502@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48AAAFAC.9050502@s5r6.in-berlin.de>
Sender: linux-ide-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Gwendal Grignou <gwendal@google.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 19, 2008 at 01:34:04PM +0200, Stefan Richter wrote:
> Gwendal Grignou wrote:
> > This patch adds objects for accessing libata objects from user space:
> > - ata_port class: one per ATA port
> > - ata_link class: one per ATA port or 15 for SATA Port Multiplier
> > - ata_device class: up to 2 for PATA link, usually one for SATA.
> 
> Two outsider questions:
> 
> You are adding a userspace interface.  What are the stability commitments?

To channel GregKH, you need to document them in Documentation/ABI/

> Could you make it configurable, so that people who don't need this
> interface can build the kernel without it?

Please, no.  Don't we already have enough CONFIG options?

I think a more important question is ... this is coming from a Google
address, but has a Copyright Dell on it.  Where's the sign-off chain for
this?  Who's the author really?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
