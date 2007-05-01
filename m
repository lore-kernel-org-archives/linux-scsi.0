From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BAD_SG_DMA panic in aha1542
Date: Tue, 1 May 2007 15:33:12 +0200
Message-ID: <20070501133312.GD4653@kernel.dk>
References: <20070501021032.61120DBA1@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:28427 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423459AbXEANdu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 May 2007 09:33:50 -0400
Content-Disposition: inline
In-Reply-To: <20070501021032.61120DBA1@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

On Mon, Apr 30 2007, Bob Tracy wrote:
> rct wrote:
> > Apologies to all concerned for an unfortunate delay in resolving this.
> > (...)
> > I'll go retrieve a more conservatively-configured source tree (closer to
> > what DSL-N uses) and start over...
> 
> Success with the Debian 2.6.18-4-486 build, which is known to work
> almost as well on the test platform as the 2.6.12 kernel that DSL-N
> comes with.  I used an older compiler than Debian used for their
> production build, so I binary-patched the aha1542.ko and sr_mod.ko
> files so insmod wouldn't complain about different vermagic strings.
> 
> That's as close as it gets without redoing everything from scratch.
> I'll give Alan's and James' patches a go within the next 13 hours.
> 
> (Alan: what *else* would you name a variable associated with a bounce
> buffer besides Zebedee?  Thanks for the occasion to smile...)

Try Alan's patch, it should fix it. As mentioned earlier in this thread,
the real fix is to get rid of the cgc stuff and inject into the block
layer from cdrom.c. But Alan's patch should work-around the issue for
now.

-- 
Jens Axboe

