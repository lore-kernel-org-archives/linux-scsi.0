From: Jens Axboe <axboe@suse.de>
Subject: Re: Maybe a patch?
Date: Wed, 22 Jan 2003 08:59:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030122075943.GW20780@suse.de>
References: <Pine.LNX.4.44.0301211606060.27122-100000@wizardsworks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0301211606060.27122-100000@wizardsworks.org>
List-Id: linux-scsi@vger.kernel.org
To: Sir Ace <chandleg@wizardsworks.org>, linux-scsi@vger.kernel.org

On Tue, Jan 21 2003, Sir Ace wrote:
> 
> I saw in /usr/src/linux/drivers/net/tg3.c
> That the following was added...  I have no idea why..
> Like I said I am not a developer nor do I know a lot about this part of
> the kernel.  But it now compiles:
> 
> Added to /usr/src/linux/drivers/scsi/scsi_merge.c
> 
> #ifndef PCI_DMA_BUS_IS_PHYS
> #define PCI_DMA_BUS_IS_PHYS 1
> #endif

Please don't do stuff like that, it _could_ be dangerous to your data
when you don't know what you are doing.

That said, it is correct for hppa it seems. asm/pci.h has the same
thing, do you are just looking at a missing include. You should fix that
instead. page_to_phys() is also there.

-- 
Jens Axboe

