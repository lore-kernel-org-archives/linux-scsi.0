From: Brad Boyer <flar@allandria.com>
Subject: Re: mac_scsi / mac_NC5380
Date: Sun, 23 Nov 2003 10:54:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031123185433.GA2230@pants.nu>
References: <20031122114135.GA8147@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-216-102-214-42.dsl.snfc21.pacbell.net ([216.102.214.42]:16388
	"EHLO cynthia.pants.nu") by vger.kernel.org with ESMTP
	id S263389AbTKWSyg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2003 13:54:36 -0500
Content-Disposition: inline
In-Reply-To: <20031122114135.GA8147@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org

On Sat, Nov 22, 2003 at 12:41:35PM +0100, Christoph Hellwig wrote:
> In mailine mac_scsi uses the generic NC5380 core, not the slightly
> modified copy mac_NC5380.c that someone created for it long time
> ago.  Is it actually working that way in some tree?  I'd love to
> get rid of mac_NC5380 if possible so we're down three from four
> slightly differrent "generic" NC5380 drivers.

I had it working in the 2.2.x tree with the standard NCR5380.[ch]
for PIO, but I was trying to get DMA working (for the IIfx) and
had to make a lot of changes to properly support DMA. I never
got the interrupt handling fixed, so I'm not sure if I actually
fixed all of it. It didn't used to compile when configured to
use REAL_DMA.

In fact, the 2.2 tree I have only has two different versions of
the core 5380 support. The atari version has to add some hooks
in odd places to make their DMA engine happy.

None of the trees I have checked out (2.2, 2.4, 2.6) actually
seem to use mac_NCR5380.c, even if it is there, but 2.4 was
never really supported for mac68k.

> If someone looked into porting the other drivers to main generic
> one that would of course be cool, especially as it got some major
> work from Alan lately and does proper looking, error handling, etc..

I'll try to look at mac_scsi again, but my list is pretty long now.

	Brad Boyer
	flar@allandria.com

