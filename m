From: Sir Ace <chandleg@wizardsworks.org>
Subject: Re: Maybe a patch?
Date: Wed, 22 Jan 2003 10:32:19 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301221029160.27973-100000@wizardsworks.org>
References: <20030122075943.GW20780@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030122075943.GW20780@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org


On Wed, 22 Jan 2003, Jens Axboe wrote:

> On Tue, Jan 21 2003, Sir Ace wrote:
> >
> > I saw in /usr/src/linux/drivers/net/tg3.c
> > That the following was added...  I have no idea why..
> > Like I said I am not a developer nor do I know a lot about this part of
> > the kernel.  But it now compiles:
> >
> > Added to /usr/src/linux/drivers/scsi/scsi_merge.c
> >
> > #ifndef PCI_DMA_BUS_IS_PHYS
> > #define PCI_DMA_BUS_IS_PHYS 1
> > #endif
>
> Please don't do stuff like that, it _could_ be dangerous to your data
> when you don't know what you are doing.
>
> That said, it is correct for hppa it seems. asm/pci.h has the same
> thing, do you are just looking at a missing include. You should fix that
> instead. page_to_phys() is also there.

  Right, I was more asking than anything...  I'm not a full time
developer, and what little I do know about the kernel, is in other
sections.  I just took a quick guess at what I thought it might be.

Thanks for the correction, and I will remove the defines and add the
#include <asm/pci.h> and see if that will resolve some of the problems I
am having farther down the line in the compile.
  Thanks.
    -- Sir Ace

